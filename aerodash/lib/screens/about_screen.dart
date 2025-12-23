import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('О приложении')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.airplanemode_active, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text('Aero Dash', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Версия 1.0.0'),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Симулятор полета с настраиваемой физикой.',
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            const Text('2025 © GravityTeam'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}