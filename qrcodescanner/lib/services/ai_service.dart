import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'history_service.dart';

class AIService {
  static String? _cachedUrl;
  static String? _cachedKey;

  static Future<bool> _loadConfig() async {
    if (_cachedUrl != null && _cachedKey != null) return true;
    try {
      final content = await rootBundle.loadString('assets/api.txt');
      final lines = content.split('\n').map((e) => e.trim()).where((s) => s.isNotEmpty).toList();
      if (lines.length >= 2) {
        _cachedUrl = lines[0]; // Mistral URL
        _cachedKey = lines[1]; // Mistral Key
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  static Future<String> analyzeQRCode(String data) async {
    if (!await _loadConfig()) return "Ошибка конфигурации ИИ";

    try {
      final response = await http.post(
        Uri.parse(_cachedUrl!),
        headers: {
          'Authorization': 'Bearer $_cachedKey',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "model": "mistral-small-latest",
          "messages": [
            {"role": "system", "content": "Ты эксперт по безопасности. Проанализируй данные на русском."},
            {"role": "user", "content": data}
          ]
        }),
      ).timeout(const Duration(seconds: 15));

      final responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        final content = decoded['choices'][0]['message']['content'];
        
        // Пытаемся сохранить в БД (HistoryService)
        try {
          await HistoryService.addRecord(data, content);
        } catch (e) {
          print("Ошибка записи в БД: $e");
        }
        
        return content;
      } else {
        return "Ошибка AI: ${response.statusCode}";
      }
    } catch (e) {
      return "Ошибка сети: $e";
    }
  }
}