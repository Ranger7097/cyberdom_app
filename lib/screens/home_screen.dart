import 'package:cyberdom_app/services/logout_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  final double balance;
  final int points;
  final double bonusBalance;
  final int coinBalance;
  final String createdAt;

  const HomeScreen({
    super.key,
    required this.name,
    required this.balance,
    required this.points,
    required this.bonusBalance,
    required this.coinBalance,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => logout(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Создан: $createdAt',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 30),

            // Баланс
            _buildInfoCard(
              label: 'Баланс',
              value: '\UZS ${balance.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet,
            ),

            // Бонусный баланс
            _buildInfoCard(
              label: 'Бонусный баланс',
              value: '\UZS ${bonusBalance.toStringAsFixed(2)}',
              icon: Icons.card_giftcard,
            ),

            // Очки
            _buildInfoCard(
              label: 'Очки',
              value: points.toString(),
              icon: Icons.star,
            ),

            // Монеты
            _buildInfoCard(
              label: 'Монеты',
              value: coinBalance.toString(),
              icon: Icons.monetization_on,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
