import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'how_to_play_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.airplanemode_active, size: 100, color: Colors.blueAccent),
            const Text('AERO DASH', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            _menuBtn(context, 'В ПОЛЕТ', const GameScreen(), isPrimary: true),
            const SizedBox(height: 15),
            _menuBtn(context, 'НАСТРОЙКИ', const SettingsScreen()),
            const SizedBox(height: 15),
            _menuBtn(context, 'КАК ИГРАТЬ', const HowToPlayScreen()),
            const SizedBox(height: 15),
            _menuBtn(context, 'ОБ ИГРЕ', const AboutScreen()),
          ],
        ),
      ),
    );
  }

  Widget _menuBtn(BuildContext context, String text, Widget screen, {bool isPrimary = false}) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blueAccent : Colors.grey[800],
          foregroundColor: Colors.white,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => screen)),
        child: Text(text),
      ),
    );
  }
}