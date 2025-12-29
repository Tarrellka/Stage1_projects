import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '/l10n/app_localizations.dart'; 
import '../screens/result_screen.dart'; 

class ScannerController extends ChangeNotifier {
  final MobileScannerController cameraController = MobileScannerController();
  
  String rawCode = "";
  bool isAnalyzing = false;

  void onDetect(BarcodeCapture capture, BuildContext context) async {
    if (isAnalyzing || rawCode.isNotEmpty) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode != null && barcode.rawValue != null) {
      isAnalyzing = true;
      rawCode = barcode.rawValue!;
      notifyListeners();

      await cameraController.stop(); 
      
      if (context.mounted) {
        _navigateToResult(context, rawCode);
      }
    }
  }

  Future<void> scanImageFromGallery(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      isAnalyzing = true;
      notifyListeners();
      
      try {
        final BarcodeCapture? capture = await cameraController.analyzeImage(image.path);
        
        isAnalyzing = false;
        if (capture != null && capture.barcodes.isNotEmpty) {
          rawCode = capture.barcodes.first.rawValue ?? "";
          if (rawCode.isNotEmpty && context.mounted) {
            _navigateToResult(context, rawCode);
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.noQrFound)), // "QR-код не найден на фото"
            );
          }
        }
      } catch (e) {
        isAnalyzing = false;
        debugPrint("Gallery scan error: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorReadingFile)), // "Ошибка при чтении файла"
          );
        }
      }
      notifyListeners();
    }
  }

  void copy(BuildContext context, String text) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.copyDataMessage), // "Данные QR скопированы"
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void reset(BuildContext context) async {
    rawCode = "";
    isAnalyzing = false;
    await cameraController.start();
    notifyListeners();
  }

  void _navigateToResult(BuildContext context, String code) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(code: code),
      ),
    ).then((_) {
      if (context.mounted) {
        reset(context);
      }
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}