// ignore: library_prefixes
import 'package:cyberdom_app/services/auth_service.dart' as AuthService;
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _token != null;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await AuthService.login(
      username: username,
      password: password,
    );

    _isLoading = false;
    if (result['success']) {
      _token = result['data']['token'];
    } else {
      _error = result['message'];
    }

    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
