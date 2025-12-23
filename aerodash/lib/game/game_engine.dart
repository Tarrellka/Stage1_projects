import 'dart:math';
import 'models/game_object.dart';
import 'game_settings.dart';

class GameEngine {
  GameObject? plane; 
  List<GameObject> obstacles = [];
  bool isGameOver = false;
  int score = 0;

  double _verticalVelocity = 0.0; 

  // Считываем актуальные настройки из синглтона
  double get _gravity => GameSettings().gravity;
  double get _thrust => GameSettings().thrust;
  double get _gameSpeed => GameSettings().gameSpeed;

  void start(double screenWidth, double screenHeight) {
    _verticalVelocity = 0.0;
    final s = GameSettings();

    // Размер самолета теперь всегда актуален
    double baseSize = 40.0; 
    plane = GameObject(
      x: 50, 
      y: screenHeight / 2, 
      width: baseSize * s.planeScale, 
      height: baseSize * 0.8 * s.planeScale
    );
    
    obstacles.clear();
    isGameOver = false;
    score = 0;
  }

  void update(double screenHeight) {
    if (isGameOver || plane == null) return;

    // Применяем гравитацию из настроек
    _verticalVelocity += _gravity * 1.2; 
    if (_verticalVelocity > 15) _verticalVelocity = 15;
    plane!.y += _verticalVelocity;

    // Двигаем препятствия со скоростью из настроек
    for (var obs in obstacles) {
      obs.x -= _gameSpeed;
    }

    obstacles.removeWhere((obs) {
      if (obs.x + obs.width < 0) {
        if (obs.y == 0) score++; 
        return true;
      }
      return false;
    });

    for (var obs in obstacles) {
      if (_checkCollision(plane!, obs)) isGameOver = true;
    }

    if (plane!.y < 0 || plane!.y > screenHeight - plane!.height) {
      isGameOver = true;
    }
  }

  bool _checkCollision(GameObject p, GameObject o) {
    double pPadding = p.width * 0.15; 
    return (p.x + pPadding) < (o.x + o.width) &&
           (p.x + p.width - pPadding) > o.x &&
           (p.y + pPadding) < (o.y + o.height) &&
           (p.y + p.height - pPadding) > o.y;
  }

  void jump() {
    if (plane != null && !isGameOver) {
      // Применяем тягу из настроек
      _verticalVelocity = -12.0 * _thrust; 
    }
  }

  void spawnObstacle(double screenWidth, double screenHeight) {
    if (obstacles.isNotEmpty && obstacles.last.x > screenWidth - 300) return;
    
    double gapHeight = 220.0; 
    double minH = 50.0;
    double maxH = screenHeight - gapHeight - minH;
    double topH = minH + Random().nextDouble() * (maxH - minH);
    
    obstacles.add(GameObject(x: screenWidth, y: 0, width: 60, height: topH));
    obstacles.add(GameObject(x: screenWidth, y: topH + gapHeight, width: 60, height: screenHeight - (topH + gapHeight)));
  }

  double get rotationAngle => (_verticalVelocity * 0.04).clamp(-0.5, 0.5);
}