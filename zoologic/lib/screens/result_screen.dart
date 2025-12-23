import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("КОНЕЦ ИГРЫ", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text("Ваш счет: $score", style: TextStyle(fontSize: 24, color: Colors.green)),
            SizedBox(height: 30),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("В МЕНЮ")),
          ],
        ),
      ),
    );
  }
}