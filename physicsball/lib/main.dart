import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/how_to_play_screen.dart'; 
import 'screens/about_screen.dart';       

void main() {
  runApp(const GravityBallApp());
}

class GravityBallApp extends StatelessWidget {
  const GravityBallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/game': (context) => const GameScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/how_to_play': (context) => const HowToPlayScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}