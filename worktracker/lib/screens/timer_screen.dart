import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/timer_controller.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Подключаем наш контроллер логики
    return ChangeNotifierProvider(
      create: (_) => TimerController(),
      child: Consumer<TimerController>(
        builder: (context, timer, child) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timer.isFocusMode ? "ФОКУС" : "ОТДЫХ",
                      style: TextStyle(
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                        color: timer.isFocusMode ? Colors.blueAccent : Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      timer.formatTime,
                      style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    _buildStartButton(timer),
                    const SizedBox(height: 60),
                    _buildInputs(timer, context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStartButton(TimerController timer) {
    return GestureDetector(
      onTap: timer.toggleTimer,
      child: Container(
        width: 90, height: 90,
        decoration: BoxDecoration(
          color: timer.isRunning ? Colors.redAccent : const Color(0xFF3366FF),
          shape: BoxShape.circle,
        ),
        child: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 45),
      ),
    );
  }

  Widget _buildInputs(TimerController timer, BuildContext context) {
    return Row(
      children: [
        _timeInputField("Фокус", timer.focusController, timer, context),
        const SizedBox(width: 20),
        _timeInputField("Отдых", timer.breakController, timer, context),
      ],
    );
  }

  Widget _timeInputField(String label, TextEditingController controller, TimerController timer, BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
        onChanged: (_) => timer.applyNewTime(),
      ),
    );
  }
}