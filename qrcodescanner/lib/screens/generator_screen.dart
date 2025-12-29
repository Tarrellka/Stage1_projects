import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:provider/provider.dart';
import '../controllers/generator_controller.dart';
import '../l10n/app_localizations.dart';

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => GeneratorController(),
      child: Consumer<GeneratorController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.generatorTitle)),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.textController,
                      decoration: InputDecoration(
                        labelText: l10n.generatorInputLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.link),
                      ),
                      onChanged: controller.updateData,
                    ),
                    const SizedBox(height: 40),
                    if (controller.qrData.isNotEmpty)
                      _buildQrPreview(context, controller, l10n, screenWidth)
                    else
                      _buildPlaceholder(context, l10n),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQrPreview(BuildContext context, GeneratorController controller, AppLocalizations l10n, double width) {
    return Column(
      children: [
        Screenshot(
          controller: controller.screenshotController,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: QrImageView(
              data: controller.qrData,
              version: QrVersions.auto,
              size: width * 0.5,
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () async {
            final success = await controller.saveQrCode();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(success ? l10n.saveSuccess : l10n.saveError)),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.download),
          label: Text(l10n.saveToGallery),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: Column(
        children: [
          Icon(Icons.qr_code_2, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(l10n.generatorPlaceholder, style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}