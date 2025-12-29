import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';
import '../main.dart'; 

class ResultController extends ChangeNotifier {
  String aiAnalysis = "";
  bool isLoading = true;
  final DatabaseService _db = DatabaseService();

  Future<void> init(String code, String loadingText, String langCode, String errorText, String systemPrompt) async {
    aiAnalysis = loadingText;
    await _fetchAndSave(code, errorText, systemPrompt);
  }

  Future<void> _fetchAndSave(String code, String errorText, String systemPrompt) async {
    isLoading = true;
    notifyListeners();

    try {
      // Запрос к ИИ
      final result = await AIService.analyzeQRCode(
        code, 
        systemPrompt: systemPrompt, 
      );
      
      aiAnalysis = result;
      
      // Сохраняем в БД (метод теперь безопасен)
      await _db.saveScan(code, result);
      
      historyUpdateNotifier.value++; 
    } catch (e) {
      debugPrint("AI Process Error: $e");
      aiAnalysis = errorText;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}