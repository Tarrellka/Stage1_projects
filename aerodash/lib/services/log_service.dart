import 'dart:developer' as developer;

class LogService {
  // Статический метод, чтобы можно было вызывать без создания объекта класса
  static void logSettingChange(String settingName, double value) {
    // Превращаем 0.5 в 50% для наглядности
    final int percent = (value * 100).toInt();
    
    // Выводим в консоль с меткой [AERO DASH]
    developer.log(
      'Изменение параметра: $settingName -> $percent%',
      name: 'com.example.aero_dash',
      time: DateTime.now(),
    );
  }

  static void logGameEvent(String event) {
    developer.log(
      'Событие игры: $event',
      name: 'com.example.aero_dash',
      time: DateTime.now(),
    );
  }
}