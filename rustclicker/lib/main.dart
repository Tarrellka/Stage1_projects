import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() => runApp(const RustClicker());

class RustClicker extends StatelessWidget {
  const RustClicker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rust Clicker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Цвет темного металла
      ),
      home: const GameScreen(),
    );
  }
}