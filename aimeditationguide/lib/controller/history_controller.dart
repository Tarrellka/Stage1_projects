import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Map<String, dynamic>> meditationHistory = [];
  bool isLoading = true;

  // Название коллекции в Firebase
  final String _collectionName = 'meditation_history';

  // Загрузка данных из облака
  Future<void> loadHistory() async {
    isLoading = true;
    notifyListeners();

    try {
      // Получаем документы, сортируя по дате (свежие сверху)
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('date', descending: true)
          .get();

      meditationHistory = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id, // ID документа нужен для удаления
          'title': data['title'] ?? '',
          'image': data['image'] ?? '',
          'date': data['date'] ?? DateTime.now().toIso8601String(),
        };
      }).toList();
    } catch (e) {
      debugPrint("Ошибка при загрузке истории из Firebase: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Сохранение новой записи (вызывай этот метод в конце медитации)
  Future<void> addHistoryItem(String title, String imageUrl) async {
    try {
      await _firestore.collection(_collectionName).add({
        'title': title,
        'image': imageUrl,
        'date': DateTime.now().toIso8601String(),
      });
      // Обновляем локальный список после добавления
      await loadHistory();
    } catch (e) {
      debugPrint("Ошибка при сохранении: $e");
    }
  }

  // Удаление записи
  Future<void> deleteItem(int index) async {
    try {
      final String docId = meditationHistory[index]['id'];
      await _firestore.collection(_collectionName).doc(docId).delete();
      
      meditationHistory.removeAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint("Ошибка при удалении: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}