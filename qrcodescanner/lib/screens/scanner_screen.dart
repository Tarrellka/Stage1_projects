import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/scanner_controller.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late ScannerController _logic;

  @override
  void initState() {
    super.initState();
    _logic = ScannerController();
    _logic.addListener(() { if (mounted) setState(() {}); });
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ВЕРХНЯЯ ЧАСТЬ: КАМЕРА
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _logic.cameraController,
                  onDetect: _logic.onDetect,
                ),
                // Кнопка Галереи
                Positioned(
                  top: 50,
                  right: 20,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.black54,
                    onPressed: () => _logic.scanImageFromGallery(context),
                    child: const Icon(Icons.photo_library, color: Colors.white),
                  ),
                ),
                // Заглушка при успехе
                if (_logic.isAnalyzing || _logic.aiResult != "Наведите камеру на QR-код")
                  Container(
                    color: Colors.black87,
                    child: const Center(
                      child: Icon(Icons.qr_code_2, color: Colors.deepPurpleAccent, size: 100),
                    ),
                  ),
              ],
            ),
          ),
          
          // НИЖНЯЯ ЧАСТЬ: ИНФОРМАЦИЯ
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("AI Анализ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Row(
                        children: [
                          if (_logic.rawCode.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.link),
                              onPressed: () => _logic.copy(context, _logic.rawCode, "Данные QR скопированы"),
                            ),
                          if (!_logic.isAnalyzing && _logic.aiResult.length > 10)
                            IconButton(
                              icon: const Icon(Icons.copy_all),
                              onPressed: () => _logic.copy(context, _logic.aiResult, "Анализ скопирован"),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _logic.aiResult,
                        style: TextStyle(color: Colors.grey[800], fontSize: 15),
                      ),
                    ),
                  ),
                  if (!_logic.isAnalyzing && _logic.aiResult != "Наведите камеру на QR-код")
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _logic.reset,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Сканировать еще"),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}