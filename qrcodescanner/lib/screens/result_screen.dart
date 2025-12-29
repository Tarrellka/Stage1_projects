import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../controllers/result_controller.dart';
import '../l10n/app_localizations.dart';

class ResultScreen extends StatelessWidget {
  final String code;
  const ResultScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final String langCode = Localizations.localeOf(context).languageCode;

    return ChangeNotifierProvider(
      create: (_) => ResultController()..init(
    code, 
    l10n.aiAnalyzingProgress, 
    langCode, 
    l10n.errorAnalysis,
    l10n.aiSystemPrompt 
  ),
      child: Consumer<ResultController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.resultScreenTitle),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(l10n.codeContentLabel),
                          _buildDataCard(code),
                          const SizedBox(height: 25),
                          _buildAIHeader(l10n, screenWidth),
                          const SizedBox(height: 10),
                          _buildAIAnalysisCard(controller),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButtons(context, l10n, code),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Вспомогательные методы верстки ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(), 
      style: const TextStyle(
        color: Colors.grey, 
        fontSize: 12, 
        fontWeight: FontWeight.bold, 
        letterSpacing: 1.1
      ),
    );
  }

  Widget _buildDataCard(String data) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SelectableText(
        data,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'monospace'),
      ),
    );
  }

  Widget _buildAIHeader(AppLocalizations l10n, double width) {
    return Row(
      children: [
        const Icon(Icons.auto_awesome, color: Colors.deepPurple, size: 22),
        const SizedBox(width: 8),
        Text(
          l10n.aiSecurityAnalysisTitle,
          style: TextStyle(
            fontSize: width > 600 ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAIAnalysisCard(ResultController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.1)),
      ),
      child: controller.isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
            )
          : Text(
              controller.aiAnalysis, 
              style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)
            ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, AppLocalizations l10n, String data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: data));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.copyButton), behavior: SnackBarBehavior.floating),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.copy),
              label: Text(l10n.copyButton),
            ),
          ),
          if (data.toLowerCase().startsWith("http")) ...[
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => launchUrl(Uri.parse(data), mode: LaunchMode.externalApplication),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.open_in_browser),
                label: Text(l10n.openButton),
              ),
            ),
          ],
        ],
      ),
    );
  }
}