import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../game/quiz_engine.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Difficulty difficulty;
  QuizScreen({required this.difficulty});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizEngine _engine = QuizEngine();

  @override
  void initState() {
    super.initState();
    _engine.start(widget.difficulty);
  }

  void _onAnswer(String name) {
    bool correct = _engine.checkAnswer(name);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(correct ? "Верно!" : "Это был ${_engine.currentAnimal.name}"),
      backgroundColor: correct ? Colors.green : Colors.red,
      duration: Duration(milliseconds: 500),
    ));

    setState(() {
      _engine.nextQuestion();
      if (_engine.isFinished) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(score: _engine.score)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Угадай животное"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: constraints.maxWidth, maxHeight: constraints.maxHeight),
                          child: Text(
                            _engine.currentAnimal.description,
                            style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: LayoutBuilder(builder: (context, constraints) {
                double ratio = constraints.maxWidth / (constraints.maxHeight / (widget.difficulty == Difficulty.hard ? 2.8 : 1.8));
                return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: ratio > 3.5 ? ratio : 3.0,
                  physics: NeverScrollableScrollPhysics(),
                  children: _engine.options.map((name) => ElevatedButton(
                    onPressed: () => _onAnswer(name),
                    child: FittedBox(child: Text(name, style: TextStyle(fontSize: 20))),
                  )).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}