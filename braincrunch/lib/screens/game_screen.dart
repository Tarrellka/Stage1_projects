import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/math_engine.dart';

class GameScreen extends StatefulWidget {
  final MathDifficulty difficulty;
  const GameScreen({super.key, required this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MathEngine _engine = MathEngine();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _engine.generateQuestion(widget.difficulty);
  }

  void _handleAnswer() {
    if (_controller.text.isEmpty) return;

    int? userVal = int.tryParse(_controller.text);
    if (userVal == null) return;

    bool correct = _engine.checkAnswer(userVal);
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(correct ? "CRUNCHED!" : "MISS! Answer: ${_engine.correctAnswer}"),
      backgroundColor: correct ? Colors.green : Colors.red,
      duration: const Duration(milliseconds: 600),
    ));

    setState(() {
      _controller.clear();
      _engine.generateQuestion(widget.difficulty);
      _focusNode.requestFocus(); 
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана для расчетов
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // ResizeToAvoidBottomInset позволяет контенту сжиматься, когда вылезает клавиатура
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        title: Text("Score: ${_engine.score} | Combo: ${_engine.combo}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              // 1. СЕКЦИЯ ПРИМЕРА (Занимает доступное пространство)
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        _engine.currentExpression,
                        style: const TextStyle(
                          fontSize: 100, // Базовый размер для FittedBox
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. АДАПТИВНЫЙ БЛОК ВВОДА
              Container(
                constraints: BoxConstraints(maxWidth: 400), // Чтобы на планшетах не было слишком широко
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (screenHeight * 0.05).clamp(24, 48), 
                        fontWeight: FontWeight.bold
                      ),
                      decoration: InputDecoration(
                        hintText: "???",
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
                        ),
                      ),
                      onSubmitted: (_) => _handleAnswer(),
                    ),
                    
                    const SizedBox(height: 15),

                    // АДАПТИВНАЯ КНОПКА
                    SizedBox(
                      width: double.infinity,
                      height: (screenHeight * 0.08).clamp(60, 85),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: _handleAnswer,
                        child: const FittedBox(
                          child: Text(
                            "Проверить", 
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}