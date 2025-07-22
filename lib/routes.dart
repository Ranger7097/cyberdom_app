import 'package:cyberdom_app/main.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case home:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => HomeScreen(
              name: args['name'] ?? '',
              balance: args['balance'] ?? 0.0,
              points: args['points'] ?? 0,
              bonusBalance: args['bonusBalance'] ?? 0.0,
              coinBalance: args['coinBalance'] ?? 0,
              createdAt: args['createdAt'] ?? '',
            ),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Ошибка маршрута'))),
    );
  }
}
