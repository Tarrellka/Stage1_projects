import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'dart:typed_data';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  String _qrData = "";

  Future<void> _saveQrCode() async {
    try {
      // Захватываем виджет в байты (PNG)
      final Uint8List? image = await _screenshotController.capture();
      
      if (image != null) {
        // Сохраняем напрямую в галерею
        await Gal.putImageBytes(image);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("QR-код сохранен в галерею!")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка при сохранении")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Создать QR")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Введите текст или ссылку",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              onChanged: (value) => setState(() => _qrData = value),
            ),
            const SizedBox(height: 30),
            if (_qrData.isNotEmpty)
              Column(
                children: [
                  // Оборачиваем QR в Screenshot для захвата
                  Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                        gapless: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _saveQrCode,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    icon: const Icon(Icons.download),
                    label: const Text("Сохранить в галерею"),
                  ),
                ],
              )
            else
              const Center(
                heightFactor: 5,
                child: Text("Введите данные для генерации"),
              ),
          ],
        ),
      ),
    );
  }
}