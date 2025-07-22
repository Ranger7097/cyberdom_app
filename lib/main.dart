import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'providers/auth_provider.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // обязательно
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'iCafe App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _connectionError;

  @override
  void initState() {
    super.initState();

    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.tryAutoLogin();

    if (authProvider.isLoggedIn) {
      final data = authProvider.member!;
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {
          'name': data['member_account'] ?? '',
          'balance':
              double.tryParse(data['member_balance']?.toString() ?? '0') ?? 0,
          'points': int.tryParse(data['member_points']?.toString() ?? '0') ?? 0,
          'bonusBalance':
              double.tryParse(
                data['member_balance_bonus']?.toString() ?? '0',
              ) ??
              0,
          'coinBalance':
              int.tryParse(data['member_coin_balance']?.toString() ?? '0') ?? 0,
          'createdAt': data['member_create'] ?? '',
        },
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _checkInternetAndNavigate() async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      setState(() {
        _connectionError = 'Нет подключения к интернету';
      });
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (auth.isLoggedIn && auth.member != null) {
      final member = auth.member!;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: {
          'name': member['member_account'] ?? '',
          'phone': member['member_phone'] ?? '',
          'balance': double.tryParse(member['member_balance'] ?? '0') ?? 0.0,
        },
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _connectionError != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _connectionError!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkInternetAndNavigate,
                    child: const Text('Повторить'),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
