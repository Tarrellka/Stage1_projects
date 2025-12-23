import 'dart:math';

enum MathDifficulty { easy, medium, hard }

class MathEngine {
  final Random _rng = Random();
  late String currentExpression;
  late int correctAnswer;
  late List<int> options;
  int score = 0;
  int combo = 0;

  void generateQuestion(MathDifficulty diff) {
    int a, b;
    
    if (diff == MathDifficulty.easy) {
      a = _rng.nextInt(20) + 1;
      b = _rng.nextInt(20) + 1;
      if (_rng.nextBool()) {
        currentExpression = "$a + $b";
        correctAnswer = a + b;
      } else {
        if (a < b) { var t = a; a = b; b = t; }
        currentExpression = "$a - $b";
        correctAnswer = a - b;
      }
    } else if (diff == MathDifficulty.medium) {
      a = _rng.nextInt(12) + 2;
      b = _rng.nextInt(10) + 2;
      if (_rng.nextBool()) {
        currentExpression = "$a × $b";
        correctAnswer = a * b;
      } else {
        int res = a * b;
        currentExpression = "$res ÷ $a";
        correctAnswer = b;
      }
    } else {
      a = _rng.nextInt(15) + 2;
      if (_rng.nextBool()) {
        currentExpression = "$a²";
        correctAnswer = a * a;
      } else {
        b = _rng.nextInt(50) + 10;
        int c = _rng.nextInt(5) + 2;
        currentExpression = "($a × $c) + $b";
        correctAnswer = (a * c) + b;
      }
    }
    _generateOptions();
  }

  void _generateOptions() {
    Set<int> choices = {correctAnswer};
    while (choices.length < 4) {
      int offset = _rng.nextInt(10) + 1;
      int fake = _rng.nextBool() ? correctAnswer + offset : correctAnswer - offset;
      if (fake != correctAnswer && fake > 0) choices.add(fake);
    }
    options = choices.toList()..shuffle();
  }

  bool checkAnswer(int answer) {
    if (answer == correctAnswer) {
      score += 10 + (combo * 2);
      combo++;
      return true;
    } else {
      combo = 0;
      return false;
    }
  }
}