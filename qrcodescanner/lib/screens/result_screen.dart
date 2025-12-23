import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/ai_service.dart';

class ResultScreen extends StatefulWidget {
  final String code;
  const ResultScreen({super.key, required this.code});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String aiAnalysis = "Анализируем содержимое...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAIAnalysis();
  }

  // Вызов нашего AI сервиса
  Future<void> _fetchAIAnalysis() async {
    final result = await AIService.analyzeQRCode(widget.code);
    if (mounted) {
      setState(() {
        aiAnalysis = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Результат сканирования")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Содержимое кода:", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(widget.code, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 25),
            
            // --- БЛОК AI АНАЛИЗА ---
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text("AI Анализ безопасности:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
              ),
              child: isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : Text(aiAnalysis, style: const TextStyle(fontSize: 15)),
            ),
            
            const Spacer(),
            
            // --- КНОПКИ ДЕЙСТВИЯ ---
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Clipboard.setData(ClipboardData(text: widget.code)),
                    icon: const Icon(Icons.copy),
                    label: const Text("Копировать"),
                  ),
                ),
                const SizedBox(width: 10),
                if (widget.code.startsWith("http"))
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => launchUrl(Uri.parse(widget.code)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text("Открыть"),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}