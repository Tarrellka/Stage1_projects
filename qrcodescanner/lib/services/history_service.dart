import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryService {
  static const String _key = 'scan_history';

  // Сохранить новый скан
  static Future<void> saveScan(String content, String aiAnalysis) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_key) ?? [];
    
    // Создаем запись: контент, анализ и дата
    Map<String, String> newEntry = {
      'content': content,
      'analysis': aiAnalysis,
      'date': DateTime.now().toString().substring(0, 16), // ГГГГ-ММ-ДД ЧЧ:ММ
    };
    
    history.insert(0, jsonEncode(newEntry)); // Новые всегда сверху
    await prefs.setStringList(_key, history);
  }

  // Получить всю историю
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_key) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // Очистить историю
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}