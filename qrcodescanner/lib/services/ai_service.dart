import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class AIService {
  static Future<String> analyzeQRCode(String data, {required String systemPrompt}) async {
    try {
      final content = await rootBundle.loadString('assets/api.txt');
      final lines = content.split('\n').map((e) => e.trim()).where((s) => s.isNotEmpty).toList();
      
      if (lines.length < 2) return "Error: Invalid API config";

      final response = await http.post(
        Uri.parse(lines[0]),
        headers: {
          'Authorization': 'Bearer ${lines[1]}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "model": "mistral-small-latest",
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": data}
          ]
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        return decoded['choices'][0]['message']['content'];
      }
      return "Ошибка API: ${response.statusCode}";
    } catch (e) {
      return "Ошибка связи: $e";
    }
  }
}