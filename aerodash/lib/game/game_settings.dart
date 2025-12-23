class GameSettings {
  static final GameSettings _instance = GameSettings._internal();
  factory GameSettings() => _instance;

  GameSettings._internal() {
    reset();
  }

  // Физические параметры
  double thrust = 1.3;     // Было на 100%, теперь это база
  double gravity = 0.65;   // Твое любимое значение
  double spawnRate = 0.02; 
  double gameSpeed = 5.0;
  double planeScale = 1.5; // Было на 100%, теперь это база

  late Map<String, double> currentValues;

  void updateField(String name, double value) {
    currentValues[name] = value;
    switch (name) {
      case 'Тяга двигателя': 
        // Теперь 0.5 на слайдере даст 1.3
        // Формула: 0.3 + (0.5 * 2.0) = 1.3
        thrust = 0.3 + (value * 2.0); 
        break;
      case 'Гравитация': 
        // 0.5 на слайдере даст 0.65
        // Формула: 0.15 + (0.5 * 1.0) = 0.65
        gravity = 0.15 + (value * 1.0); 
        break;
      case 'Частота препятствий': 
        spawnRate = 0.01 + (value * 0.05); 
        break;
      case 'Скорость полета': 
        gameSpeed = 3.0 + (value * 12.0); 
        break;
      case 'Размер самолета': 
        // Теперь 0.5 на слайдере даст 1.5
        // Формула: 0.5 + (0.5 * 2.0) = 1.5
        planeScale = 0.5 + (value * 2.0); 
        break;
    }
  }

  void reset() {
    // Теперь по умолчанию все ползунки на 50%
    currentValues = Map<String, double>.from({
      'Тяга двигателя': 0.5,    
      'Гравитация': 0.5,       
      'Частота препятствий': 0.3,
      'Скорость полета': 0.4,
      'Размер самолета': 0.5,   
    });
    
    currentValues.forEach((key, value) {
      updateField(key, value);
    });
  }
}