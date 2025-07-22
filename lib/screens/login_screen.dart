import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cyberdom_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Лого клуба
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Image.asset(
                  'assets/logo.jpg',
                  width: 180, // увеличенный размер
                  height: 180,
                ),
              ),

              // Форма логина
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    TextField(
                      controller: usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Логин',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFF1E1E1E),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Пароль',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFF1E1E1E),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Кнопка входа
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7, // уже
                        child: ElevatedButton(
                          onPressed: auth.isLoading
                              ? null
                              : () async {
                                  // Проверка соединения
                                  final connectivity = await Connectivity()
                                      .checkConnectivity();
                                  if (connectivity == ConnectivityResult.none) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Нет подключения к интернету',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // Проверка пустых полей
                                  if (usernameController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Введите логин и пароль'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // Вход
                                  await auth.login(
                                    usernameController.text,
                                    passwordController.text,
                                  );

                                  if (auth.isLoggedIn) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Успешный вход!'),
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.home,
                                      arguments: {
                                        'name': auth.member!['member_account'],
                                        'balance':
                                            double.tryParse(
                                              auth.member!['member_balance']
                                                  .toString(),
                                            ) ??
                                            0.0,
                                        'points':
                                            int.tryParse(
                                              auth.member!['member_points']
                                                  .toString(),
                                            ) ??
                                            0,
                                        'bonusBalance':
                                            double.tryParse(
                                              auth.member!['member_balance_bonus']
                                                  .toString(),
                                            ) ??
                                            0.0,
                                        'coinBalance':
                                            int.tryParse(
                                              auth.member!['member_coin_balance']
                                                  .toString(),
                                            ) ??
                                            0,
                                        'createdAt':
                                            auth.member!['member_create'] ?? '',
                                      },
                                    );
                                    // TODO: Перейти на следующий экран
                                  } else if (auth.error != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(auth.error!)),
                                    );
                                  }
                                },
                          child: auth.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'ВОЙТИ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
