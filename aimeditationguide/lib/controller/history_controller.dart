import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryController extends ChangeNotifier {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  List<Map<String, dynamic>> meditationHistory = [];
  List<Map<String, dynamic>> breathingHistory = [];
  bool isLoading = true;

  final String _collectionName = 'meditation_history';

  Future<void> loadHistory() async {
    final user = _auth.currentUser;
    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _db
          .collection(_collectionName)
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .get();

      final allItems = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,

          'date': (data['date'] as Timestamp?)?.toDate().toIso8601String() ?? 
                   DateTime.now().toIso8601String(),
        };
      }).toList();


      meditationHistory = allItems.where((item) => item['type'] == 'ai_generated').toList();
      breathingHistory = allItems.where((item) => item['type'] == 'breathing').toList();

    } catch (e) {
      debugPrint("Ошибка при загрузке истории: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteItem(int index, bool isMeditation) async {
    try {
      final list = isMeditation ? meditationHistory : breathingHistory;
      final String docId = list[index]['id'];

      await _db.collection(_collectionName).doc(docId).delete();
      
      if (isMeditation) {
        meditationHistory.removeAt(index);
      } else {
        breathingHistory.removeAt(index);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Ошибка при удалении: $e");
    }
  }
}