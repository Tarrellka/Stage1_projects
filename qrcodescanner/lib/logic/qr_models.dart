class QRRecord {
  final String id;
  final String content;
  final DateTime date;
  final String type; // "URL", "Text", "WiFi"
  bool isSafe;      // Результат проверки AI

  QRRecord({
    required this.id,
    required this.content,
    required this.date,
    this.type = "Text",
    this.isSafe = true,
  });

  // Методы toJson / fromJson для сохранения в историю...
}