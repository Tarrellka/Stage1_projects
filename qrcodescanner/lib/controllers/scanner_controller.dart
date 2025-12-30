import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../services/analytics_service.dart';
import '/l10n/app_localizations.dart'; 
import '../screens/result_screen.dart'; 
import 'package:flutter/services.dart';

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
      
      AnalyticsService.logEvent("qr_scan_success", {"source": "camera", "format": barcode.format.name});
      
      notifyListeners();
      await cameraController.stop(); 
      if (context.mounted) _navigateToResult(context, rawCode);
    }
  }

  Future<void> scanImageFromGallery(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      isAnalyzing = true;
      notifyListeners();
      AnalyticsService.logEvent("qr_scan_gallery_attempt");

      try {
        final BarcodeCapture? capture = await cameraController.analyzeImage(image.path);
        isAnalyzing = false;
        if (capture != null && capture.barcodes.isNotEmpty) {
          rawCode = capture.barcodes.first.rawValue ?? "";
          AnalyticsService.logEvent("qr_scan_success", {"source": "gallery"});
          if (rawCode.isNotEmpty && context.mounted) _navigateToResult(context, rawCode);
        } else {
          AnalyticsService.logEvent("qr_scan_failed", {"reason": "no_code_found"});
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.noQrFound)));
        }
      } catch (e) {
        isAnalyzing = false;
        AnalyticsService.logEvent("qr_scan_error", {"error": e.toString()});
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorReadingFile)));
      }
      notifyListeners();
    }
  }

  void copy(BuildContext context, String text) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.copyDataMessage),
        duration: const Duration(seconds: 2),
      ),
    );
    AnalyticsService.logEvent("qr_scan_copy_clicked");
  }

  void reset(BuildContext context) async {
    rawCode = "";
    isAnalyzing = false;
    await cameraController.start();
    notifyListeners();
  }

  void _navigateToResult(BuildContext context, String code) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(code: code))).then((_) {
      if (context.mounted) reset(context);
    });
  }
  
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}