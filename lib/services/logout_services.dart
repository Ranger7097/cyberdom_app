import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Выход'),
      content: const Text('Вы уверены, что хотите выйти?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Нет'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Да'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    // Удаляем сохраненные логин и пароль
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login');
    await prefs.remove('password');

    // Переход на экран логина
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
