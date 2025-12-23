import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() => runApp(const BrainCrunchApp());

class BrainCrunchApp extends StatelessWidget {
  const BrainCrunchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainCrunch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
        ),
      ),
      home: const MainScreen(),
    );
  }
}