import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const AeroDashApp());
}

class AeroDashApp extends StatelessWidget {
  const AeroDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aero Dash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}