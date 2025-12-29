import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'dart:typed_data';
import '../services/analytics_service.dart';

class GeneratorController extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final ScreenshotController screenshotController = ScreenshotController();
  
  String qrData = "";
  bool hasLoggedGeneration = false;

  void updateData(String value) {
    qrData = value;
    
    // ТРЕКИНГ: Начало генерации
    if (value.isNotEmpty && !hasLoggedGeneration) {
      AnalyticsService.logEvent("qr_generation_started");
      hasLoggedGeneration = true;
    } else if (value.isEmpty) {
      hasLoggedGeneration = false;
    }
    notifyListeners();
  }

  Future<bool> saveQrCode() async {
    try {
      final Uint8List? image = await screenshotController.capture();
      if (image != null) {
        await Gal.putImageBytes(image);
        
        // ТРЕКИНГ: Успешное сохранение
        AnalyticsService.logEvent("qr_saved_to_gallery", {
          "content_length": qrData.length,
        });
        return true;
      }
    } catch (e) {
      debugPrint("Save error: $e");
    }
    return false;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}