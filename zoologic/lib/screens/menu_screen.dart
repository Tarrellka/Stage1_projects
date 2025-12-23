import 'package:flutter/material.dart';
import '../models/animal.dart';
import 'quiz_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green.shade700, Colors.blue.shade900], begin: Alignment.topCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 80, color: Colors.white),
            Text("ЗООЛОГИКА", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
            SizedBox(height: 40),
            _buildBtn(context, "ЛЕГКО", Colors.green, Difficulty.easy),
            SizedBox(height: 15),
            _buildBtn(context, "НОРМАЛЬНО", Colors.orange, Difficulty.medium),
            SizedBox(height: 15),
            _buildBtn(context, "СЛОЖНО", Colors.red, Difficulty.hard),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(BuildContext context, String text, Color color, Difficulty diff) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color, minimumSize: Size(200, 50), shape: StadiumBorder()),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(difficulty: diff))),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}