import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import '/l10n/app_localizations.dart';

class OpenAIGenerator {
  static const String baseUrl = "https://api.openai.com/v1";

  static Future<String> _getApiKey() async {
    try {
      final String key = await rootBundle.loadString('assets/api.txt');
      return key.trim().replaceAll(RegExp(r'[^a-zA-Z0-9-_]'), '');
    } catch (e) {
      throw Exception("API Key file not found");
    }
  }

  // Вспомогательный метод для ретраев
  static Future<http.Response> _postWithRetry(
    Uri url, {
    required Map<String, String> headers,
    required String body,
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await http.post(url, headers: headers, body: body)
            .timeout(const Duration(seconds: 40));


        if ((response.statusCode >= 500 || response.statusCode == 429) && attempt < maxRetries) {
          attempt++;
          await Future.delayed(Duration(seconds: pow(2, attempt).toInt())); 
          continue;
        }
        return response;
      } catch (e) {
        if (attempt >= maxRetries) rethrow;
        attempt++;
        await Future.delayed(Duration(seconds: pow(2, attempt).toInt()));
      }
    }
  }

  static Future<Map<String, dynamic>> generateMeditation({
    required String goal,
    required String duration,
    required String voice,
    required String languageCode,
    required AppLocalizations l10n,
  }) async {
    final String apiKey = await _getApiKey();
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $apiKey',
    };

    final String targetLanguage = languageCode == 'ru' ? 'Russian' : 'English';

    // 1. ГЕНЕРАЦИЯ ТЕКСТА
    final textResp = await _postWithRetry(
      Uri.parse('$baseUrl/chat/completions'),
      headers: headers,
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "system", "content": "Professional meditation guide. Script for $duration. Language: $targetLanguage."},
          {"role": "user", "content": "Goal: $goal."}
        ]
      }),
    );

    if (textResp.statusCode != 200) throw Exception("GPT Error: ${textResp.statusCode}");
    
    // ВАЛИДАЦИЯ ТЕКСТА
    final textData = jsonDecode(utf8.decode(textResp.bodyBytes));
    if (textData['choices'] == null || textData['choices'].isEmpty) throw Exception("Empty GPT response");
    String generatedText = textData['choices'][0]['message']['content'] ?? "";
    if (generatedText.isEmpty) throw Exception("Generated text is empty");

    // 2. ГЕНЕРАЦИЯ КАРТИНКИ (с фолбеком)
    String imageUrl = "https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=1080";
    try {
      final imgResp = await _postWithRetry(
        Uri.parse('$baseUrl/images/generations'),
        headers: headers,
        body: jsonEncode({
          "model": "dall-e-3",
          "prompt": "Zen meditation visual, $goal topic, peaceful nature, digital art",
          "n": 1,
          "size": "1024x1024"
        }),
      );
      if (imgResp.statusCode == 200) {
        final imgData = jsonDecode(imgResp.body);
        // ВАЛИДАЦИЯ КАРТИНКИ
        if (imgData['data'] != null && imgData['data'].isNotEmpty) {
          imageUrl = imgData['data'][0]['url'];
        }
      }
    } catch (e) {
      debugPrint("DALL-E failed, using fallback: $e");
    }

    // 3. ГЕНЕРАЦИЯ ГОЛОСА (TTS)
    String aiVoice = voice == "Deep" ? "onyx" : (voice == "Soft" ? "shimmer" : "nova");

    final ttsResp = await _postWithRetry(
      Uri.parse('$baseUrl/audio/speech'),
      headers: headers,
      body: jsonEncode({
        "model": "tts-1",
        "input": generatedText,
        "voice": aiVoice,
        "speed": 0.85 
      }),
    );

    if (ttsResp.statusCode != 200) throw Exception("TTS Error: ${ttsResp.statusCode}");
    if (ttsResp.bodyBytes.isEmpty) throw Exception("TTS returned empty audio");

    return {
      "title": l10n.sessionTitle(goal),
      "imageUrl": imageUrl,
      "voiceSource": BytesSource(ttsResp.bodyBytes),
      "text": generatedText,
    };
  }
}