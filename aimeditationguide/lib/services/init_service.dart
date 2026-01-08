import 'package:flutter/foundation.dart'; // Добавь этот импорт для debugPrint
import 'package:apphud/apphud.dart';

class InitService {
  static Future<void> initialize() async {
    try {
      // Замени на свой актуальный ключ из панели AppHud
      // Убираем await, чтобы медленный ответ сервера не вешал приложение при старте
      Apphud.start(apiKey: "app_4666W69R6Y6D6R6N6S6S6S6S6S6S6S"); 
      
      debugPrint("Apphud start attempt initiated");
    } catch (e) {
      debugPrint("Apphud Initialization Error: $e");
    }
  }
}