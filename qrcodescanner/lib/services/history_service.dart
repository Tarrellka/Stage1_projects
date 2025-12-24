import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class HistoryService {
  // Используем геттер, чтобы клиент запрашивался только после инициализации в main
  static SupabaseClient get _supabase => Supabase.instance.client;

  static Future<void> addRecord(String rawData, String aiVerdict, {int retries = 3}) async {
    if (rawData.isEmpty || aiVerdict.isEmpty) return;

    int attempt = 0;
    while (attempt < retries) {
      try {
        await _supabase.from('scan_history').insert({
          'raw_data': rawData,
          'ai_verdict': aiVerdict,
        });
        return; 
      } catch (e) {
        attempt++;
        debugPrint("Ошибка сохранения (попытка $attempt): $e");
        if (attempt >= retries) break;
        await Future.delayed(Duration(seconds: 1 * attempt)); 
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getHistory({int retries = 2}) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        final response = await _supabase
            .from('scan_history')
            .select()
            .order('created_at', ascending: false)
            .limit(50);

        return _validateHistoryList(response as List<dynamic>);
      } catch (e) {
        attempt++;
        debugPrint("Ошибка загрузки истории (попытка $attempt): $e");
        if (attempt >= retries) break;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    return [];
  }

  static List<Map<String, dynamic>> _validateHistoryList(List<dynamic> data) {
    final List<Map<String, dynamic>> validRecords = [];
    for (var item in data) {
      if (item is Map<String, dynamic> &&
          item.containsKey('raw_data') &&
          item.containsKey('ai_verdict')) {
        validRecords.add(item);
      }
    }
    return validRecords;
  }

  static Future<bool> clearHistory() async {
    try {
      await _supabase.from('scan_history').delete().neq('raw_data', '');
      return true;
    } catch (e) {
      debugPrint("Ошибка удаления истории: $e");
      return false;
    }
  }
}