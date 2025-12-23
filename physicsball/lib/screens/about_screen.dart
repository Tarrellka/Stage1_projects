import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("О приложении")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.blur_on, size: 80, color: Colors.cyanAccent),
            const SizedBox(height: 16),
            const Text("Gravity Ball v1.0.0", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Физическая песочница на Flutter", style: TextStyle(color: Colors.white70)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Divider(color: Colors.white24),
            ),
            const Text("Технологии:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Custom Physics Engine\nTicker UI Animation\nSeparation of Concerns Architecture", 
              textAlign: TextAlign.center, 
              style: TextStyle(color: Colors.cyanAccent, fontSize: 12)
            ),
            const Spacer(),
            const Text("2025 © Physics Dev Team", style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}