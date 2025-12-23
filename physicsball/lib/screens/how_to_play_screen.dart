import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("Как играть")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildStep(Icons.add_circle_outline, "Добавляйте шары", "Нажимайте на кнопку '+' внизу экрана, чтобы создать новый объект."),
          _buildStep(Icons.touch_app, "Управляйте ими", "Зажмите шар пальцем, чтобы переместить его. Отпустите в движении, чтобы придать ускорение."),
          _buildStep(Icons.settings_input_component, "Меняйте физику", "В настройках можно отключить гравитацию или сделать шары супер-прыгучими."),
          _buildStep(Icons.cleaning_services, "Очистка", "Используйте иконку обновления в верхней панели, чтобы убрать все объекты с поля."),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}