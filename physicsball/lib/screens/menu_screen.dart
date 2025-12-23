import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "GRAVITY BALL",
              style: TextStyle(
                fontSize: 42, 
                fontWeight: FontWeight.bold, 
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 60),
            
            // Кнопка ИГРАТЬ
            _buildMenuButton(context, "ИГРАТЬ", '/game', Colors.cyanAccent),
            
            const SizedBox(height: 20),
            
            // Кнопка НАСТРОЙКИ
            _buildMenuButton(context, "НАСТРОЙКИ", '/settings', Colors.white70),

            const SizedBox(height: 10),

            // Кнопка ИНСТРУКЦИЯ
            _buildMenuButton(context, "ИНСТРУКЦИЯ", '/how_to_play', Colors.white54),

            const SizedBox(height: 10),

            // Кнопка О ПРОГРАММЕ
            _buildMenuButton(context, "О ПРОГРАММЕ", '/about', Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, String route, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}