import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../game/models/ball_model.dart';
import '../game/ball.dart';
import '../game/settings_data.dart';
import '../services/logger_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<BallModel> _balls = [];
  BallModel? _draggedBall;
  double _radiusSlider = 25.0;
  final Random _rnd = Random();

  @override
void initState() {
  super.initState();
  _ticker = createTicker((_) => _tick(0.016))..start();
  LoggerService.logInfo("Игровой цикл запущен");
}

  void _tick(double dt) {
    if (!mounted) return;
    
    final size = MediaQuery.of(context).size;
    final double appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final gameSize = Size(size.width, size.height - appBarHeight);

    setState(() {
      // 1. Движение каждого шара (берем гравитацию и отскок из AppSettings)
      for (var ball in _balls) {
        if (ball != _draggedBall) {
          BallLogic.update(
            ball, 
            dt, 
            gameSize, 
            AppSettings.gravity, 
            AppSettings.bounce
          );
        }
      }

      // 2. Столкновения (только если включены в AppSettings)
      if (AppSettings.collisionsEnabled) {
        for (int i = 0; i < _balls.length; i++) {
          for (int j = i + 1; j < _balls.length; j++) {
            BallLogic.handleCollision(_balls[i], _balls[j], AppSettings.bounce);
          }
        }
      }
    });
  }

  void _addNewBall() {
  try {
    setState(() {
      _balls.add(BallModel(
        x: 100, y: 100,
        vx: (_rnd.nextDouble() - 0.5) * 500,
        radius: _radiusSlider,
        color: AppSettings.randomColors 
               ? Colors.primaries[_rnd.nextInt(Colors.primaries.length)]
               : AppSettings.ballColor,
      ));
    });
    LoggerService.logAction("Добавлен шар. Всего: ${_balls.length}");
  } catch (e, stack) {
    LoggerService.logError("Ошибка при добавлении шара", e, stack);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Gravity World"),
        actions: [
          // Кнопка очистки всех шаров
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
            setState(() => _balls.clear());
            LoggerService.logAction("Поле очищено пользователем");
          },
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              for (var ball in _balls.reversed) {
                if (Offset(details.localPosition.dx - ball.x, details.localPosition.dy - ball.y).distance < ball.radius) {
                  setState(() {
                    _draggedBall = ball;
                    ball.vx = 0; ball.vy = 0;
                  });
                  break;
                }
              }
            },
            onPanUpdate: (details) {
              if (_draggedBall != null) {
                setState(() {
                  _draggedBall!.x = details.localPosition.dx;
                  _draggedBall!.y = details.localPosition.dy;
                });
              }
            },
            onPanEnd: (details) {
              if (_draggedBall != null) {
                setState(() {
                  _draggedBall!.vx = details.velocity.pixelsPerSecond.dx;
                  _draggedBall!.vy = details.velocity.pixelsPerSecond.dy;
                  _draggedBall = null;
                });
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: _balls.map((b) => BallWidget(model: b)).toList(),
              ),
            ),
          ),
          _buildSizeSlider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBall,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSizeSlider() {
    return Positioned(
      top: 10, left: 20, right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black54, 
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 14, color: Colors.white),
            Expanded(
              child: Slider(
                value: _radiusSlider, min: 10, max: 60,
                onChanged: (v) => setState(() => _radiusSlider = v),
              ),
            ),
            Text(
              _radiusSlider.round().toString(), 
              style: const TextStyle(color: Colors.white)
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}