import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../game/game_engine.dart';
import '../game/game_settings.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameEngine _engine = GameEngine();
  Timer? _timer;

  void _startGame(double width, double height) {
    _engine.start(width, height);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      if (!mounted) return;
      setState(() {
        _engine.update(height);
        
        // Используем шанс спавна из настроек
        if (Random().nextDouble() < GameSettings().spawnRate) {
          _engine.spawnObstacle(width, height);
        }
      });
      if (_engine.isGameOver) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          if (_engine.plane == null && !_engine.isGameOver && _timer == null) {
            Future.delayed(Duration.zero, () => _startGame(w, h));
          }

          return GestureDetector(
            onTapDown: (_) => _engine.jump(),
            child: Stack(
              children: [
                // Небо
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                
                // Препятствия (Трубы)
                ..._engine.obstacles.map((obs) => Positioned(
                  left: obs.x,
                  top: obs.y,
                  child: Container(
                    width: obs.width,
                    height: obs.height,
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )),

                // Самолет
                if (_engine.plane != null)
                  Positioned(
                    left: _engine.plane!.x,
                    top: _engine.plane!.y,
                    child: Transform.rotate(
                      angle: _engine.rotationAngle,
                      child: Image.asset(
                        'assets/plane.png',
                        width: _engine.plane!.width,
                        height: _engine.plane!.height,
                        fit: BoxFit.contain,
                        // Если картинка не загрузится, покажется красная иконка ошибки
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.warning, 
                          size: _engine.plane!.width, 
                          color: Colors.red
                        ),
                      ),
                    ),
                  ),

                // Интерфейс счета
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'СЧЕТ: ${_engine.score}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black.withOpacity(0.5))],
                      ),
                    ),
                  ),
                ),

                // Экран GAME OVER
                if (_engine.isGameOver)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("КРАШ!", style: TextStyle(fontSize: 48, color: Colors.red, fontWeight: FontWeight.bold)),
                          Text("ВАШ СЧЕТ: ${_engine.score}", style: const TextStyle(fontSize: 24, color: Colors.white)),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                            onPressed: () => _startGame(w, h),
                            child: const Text("ПОПРОБОВАТЬ СНОВА"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("В ГЛАВНОЕ МЕНЮ", style: TextStyle(color: Colors.white70)),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}