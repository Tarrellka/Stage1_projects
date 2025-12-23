import 'dart:convert';
import 'package:http/http.dart' as http;
import 'history_service.dart';

class AIService {
  static const String _apiKey = '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'; 
  
  // Используем openrouter/auto для качества, 
  // но настройки берем из mistralai/mistral-7b-instruct:free для стабильности
  static Future<String> analyzeQRCode(String content) async {
    const String url = 'https://openrouter.ai/api/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://localhost',
          'X-Title': 'QR Scanner AI',
        },
        body: jsonEncode({
          "model": "openrouter/auto", // Можно поменять на mistralai/mistral-7b-instruct:free
          "max_tokens": 300,
          "temperature": 0.1,
          "messages": [
            {
              "role": "system",
              "content": "Ты эксперт по безопасности. Проверь содержимое QR-кода и кратко ответь на русском языке (безопасно или нет)."
            },
            {
              "role": "user",
              "content": "Содержимое QR: $content"
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String result = data['choices'][0]['message']['content'].trim();
        
        await HistoryService.saveScan(content, result);
        return result;
      } else {
        return "Ошибка API. Скан сохранен в историю.";
      }
    } catch (e) {
      return "Ошибка сети. Проверьте интернет.";
    }
  }
}