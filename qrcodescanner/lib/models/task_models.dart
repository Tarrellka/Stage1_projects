import 'package:cloud_firestore/cloud_firestore.dart';

class ScanModel {
  final String id;
  final String rawData;
  final String aiAnalysis;
  final DateTime timestamp;

  ScanModel({
    required this.id,
    required this.rawData,
    required this.aiAnalysis,
    required this.timestamp,
  });

  factory ScanModel.fromFirestore(DocumentSnapshot doc) {
    // Получаем данные как Map
    final data = doc.data() as Map<String, dynamic>?;

    return ScanModel(
      id: doc.id,
      rawData: data?['rawData'] ?? 'Пусто',
      aiAnalysis: data?['aiAnalysis'] ?? 'Нет анализа',
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}