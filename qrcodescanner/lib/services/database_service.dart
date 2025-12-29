import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/task_models.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Метод сохранения
  Future<void> saveScan(String rawData, String aiAnalysis) async {
    try {
      await _firestore.collection('scans_history').add({
        'rawData': rawData,
        'aiAnalysis': aiAnalysis,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("✅ Сохранено в Firestore");
    } catch (e) {
      debugPrint("❌ Ошибка сохранения: $e");
    }
  }

  // Метод для полной очистки истории
  Future<void> clearAllHistory() async {
    try {
      // Получаем все документы из коллекции
      final snapshots = await _firestore.collection('scans_history').get();
      
      // Создаем пакетную операцию для удаления (так быстрее и надежнее)
      WriteBatch batch = _firestore.batch();
      
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      debugPrint("🧹 Вся история успешно удалена");
    } catch (e) {
      debugPrint("❌ Ошибка при удалении истории: $e");
    }
  }

  // Стрим для получения данных в реальном времени
  Stream<List<ScanModel>> get historyStream {
    return _firestore
        .collection('scans_history')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          debugPrint("📥 Получено документов из базы: ${snapshot.docs.length}");
          return snapshot.docs.map((doc) => ScanModel.fromFirestore(doc)).toList();
        });
  }
}