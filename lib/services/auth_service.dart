import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> login({
  required String username,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('http://185.217.131.126:8000/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'member_account': username, 'member_password': password}),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    final bool isVerified = json['data']['verify'] == true;

    if (isVerified) {
      return {'success': true, 'data': json['data']['member']};
    } else {
      return {'success': false, 'message': 'Неверный логин или пароль'};
    }
  } else {
    return {
      'success': false,
      'message': 'Ошибка сервера: ${response.statusCode}',
    };
  }
}
