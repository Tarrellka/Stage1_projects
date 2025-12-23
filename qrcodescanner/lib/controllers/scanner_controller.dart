import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';
import '../main.dart'; 

class ScannerController extends ChangeNotifier {
  String aiResult = "Наведите камеру на QR-код";
  String rawCode = "";
  bool isAnalyzing = false;
  final MobileScannerController cameraController = MobileScannerController();

  // Сканирование через камеру
  Future<void> onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && !isAnalyzing) {
      final String code = barcodes.first.rawValue ?? "";
      if (code.isEmpty) return;
      _processCode(code);
    }
  }

  // Сканирование из галереи
  Future<void> scanImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      isAnalyzing = true;
      aiResult = "Читаю изображение...";
      notifyListeners();

      try {
        final BarcodeCapture? capture = await cameraController.analyzeImage(image.path);
        if (capture != null && capture.barcodes.isNotEmpty) {
          _processCode(capture.barcodes.first.rawValue ?? "");
        } else {
          aiResult = "QR-код не найден на фото";
          isAnalyzing = false;
          notifyListeners();
        }
      } catch (e) {
        aiResult = "Ошибка при чтении файла";
        isAnalyzing = false;
        notifyListeners();
      }
    }
  }

  // Общая логика обработки и отправки в AI
  Future<void> _processCode(String code) async {
    isAnalyzing = true;
    rawCode = code;
    aiResult = "Анализирую безопасность...";
    notifyListeners();

    await cameraController.stop();
    
    try {
      aiResult = await AIService.analyzeQRCode(code);
      historyUpdateNotifier.value++; // Обновляем вкладку истории
    } catch (e) {
      aiResult = "Ошибка анализа. Проверьте интернет.";
    }

    isAnalyzing = false;
    notifyListeners();
  }

  Future<void> reset() async {
    aiResult = "Наведите камеру на QR-код";
    rawCode = "";
    isAnalyzing = false;
    notifyListeners();
    await cameraController.start();
  }

  void copy(BuildContext context, String text, String msg) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}