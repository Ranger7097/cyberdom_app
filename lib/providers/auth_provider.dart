// ignore: library_prefixes
import 'package:cyberdom_app/services/auth_service.dart' as AuthService;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _member;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get member => _member;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _member != null;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (username.trim().isEmpty || password.trim().isEmpty) {
      _isLoading = false;
      _error = 'Введите логин и пароль';
      notifyListeners();
      return;
    }

    final result = await AuthService.login(
      username: username,
      password: password,
    );

    _isLoading = false;

    if (result['success']) {
      _member = result['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('password', password);
    } else {
      _member = null;
      _error = result['message'];
    }

    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username != null && password != null) {
      await login(username, password);
    }
  }

  void logout() {
    _member = null;
    notifyListeners();
  }
}
