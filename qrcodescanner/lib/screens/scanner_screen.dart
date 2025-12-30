import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../controllers/scanner_controller.dart';
import '../l10n/app_localizations.dart';
import '../services/subscription_service.dart';
import 'paywall_screen.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => ScannerController(),
      child: Consumer<ScannerController>(
        builder: (context, controller, _) {
          final bool hasResult = controller.rawCode.isNotEmpty;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                // ВЕРХНЯЯ ЧАСТЬ: СКАНЕР
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      MobileScanner(
                        controller: controller.cameraController,
                        onDetect: (capture) => controller.onDetect(capture, context),
                      ),
                      
                      if (!controller.isAnalyzing && !hasResult)
                        _buildScannerOverlay(screenWidth * 0.7),

                      _buildTopButtons(context),

                      if (controller.isAnalyzing)
                        _buildLoadingOverlay(l10n?.analyzingSafety ?? "Analyzing..."),
                    ],
                  ),
                ),
                
                // НИЖНЯЯ ЧАСТЬ: ПАНЕЛЬ РЕЗУЛЬТАТОВ
                Expanded(
                  flex: 2,
                  child: _buildInfoPanel(context, controller, l10n, hasResult),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopButtons(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<SubscriptionService>(
            builder: (context, sub, _) {
              if (sub.isPremium) return const SizedBox.shrink();
              return CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.workspace_premium, color: Colors.amber),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaywallScreen()),
                  ),
                ),
              );
            },
          ),

          CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.photo_library, color: Colors.white),
              onPressed: () {
                final controller = Provider.of<ScannerController>(context, listen: false);
                controller.scanImageFromGallery(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel(BuildContext context, ScannerController controller, AppLocalizations? l10n, bool hasResult) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n?.aiAnalysisTitle ?? "AI Analysis",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  if (hasResult && !controller.isAnalyzing)
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.deepPurple),
                      onPressed: () => controller.copy(context, controller.rawCode),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    !hasResult 
                        ? (l10n?.scanStatusInitial ?? "Point camera at a code") 
                        : (l10n?.codeDetected(controller.rawCode) ?? controller.rawCode), 
                    style: TextStyle(color: Colors.grey[850], fontSize: 16, height: 1.5),
                  ),
                ),
              ),
              if (!controller.isAnalyzing && hasResult)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => controller.reset(context),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: Text(l10n?.scanAgainButton ?? "Scan Again"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerOverlay(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  

  Widget _buildLoadingOverlay(String message) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}