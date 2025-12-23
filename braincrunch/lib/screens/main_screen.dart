import 'package:flutter/material.dart';
import '../game/math_engine.dart';
import 'game_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView( // Чтобы на маленьких экранах всё влезло
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              const Text(
                "BRAIN\nCRUNCH",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 4,
                  height: 1.0, // Уменьшаем межстрочный интервал для стиля
                ),
              ),
              const SizedBox(height: 50),
              
              _buildBtn(context, "Легко", Colors.green, MathDifficulty.easy),
              const SizedBox(height: 15),
              _buildBtn(context, "Средне", Colors.orange, MathDifficulty.medium),
              const SizedBox(height: 15),
              _buildBtn(context, "Тяжело", Colors.red, MathDifficulty.hard),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBtn(BuildContext context, String text, Color color, MathDifficulty diff) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(250, 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GameScreen(difficulty: diff)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}