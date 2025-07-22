import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> login({
  required String username,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('http://185.217.131.126:8000/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    // json может содержать session_id, user_id, etc.
    return {'success': true, 'data': json};
  } else {
    return {'success': false, 'message': 'Неверный логин или пароль'};
  }
}
