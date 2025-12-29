import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MaterialApp(home: SuperTestScreen()));
}

class SuperTestScreen extends StatefulWidget {
  const SuperTestScreen({super.key});

  @override
  State<SuperTestScreen> createState() => _SuperTestScreenState();
}

class _SuperTestScreenState extends State<SuperTestScreen> {
  String logs = "Нажмите СТАРТ для проверки...";
  bool loading = false;

  void addLog(String message) {
    setState(() => logs += "\n> $message");
    print("LOG: $message");
  }

  Future<void> startHardcoreTest() async {
    setState(() => logs = "НАЧАЛО ТЕСТА");
    loading = true;

    try {
      // 1. ПРОВЕРКА ФАЙЛА
      addLog("Читаю assets/api.txt...");
      String content;
      try {
        content = await rootBundle.loadString('assets/api.txt');
        addLog("Файл прочитан. Длина: ${content.length}");
      } catch (e) {
        addLog("ОШИБКА: Файл не найден в ассетах! Проверь pubspec.yaml");
        return;
      }

      // 2. ПАРСИНГ
      final lines = content.split('\n').map((e) => e.trim()).where((s) => s.isNotEmpty).toList();
      if (lines.length < 2) {
        addLog("ОШИБКА: В файле меньше 2 строк!");
        return;
      }
      final url = lines[0];
      final key = lines[1];
      addLog("URL: $url");
      addLog("KEY: ${key.substring(0, 4)}****");

      // 3. СЕТЬ
      addLog("Отправляю HTTP POST запрос...");
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "mistral-small-latest",
          "messages": [{"role": "user", "content": "Привет, это тест. Ответь одним словом: РАБОТАЕТ"}]
        }),
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException("Сервер не ответил за 15 секунд. Проблема с интернетом!");
      });

      addLog("Код ответа: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final text = data['choices'][0]['message']['content'];
        addLog("УСПЕХ! Ответ ИИ: $text");
      } else {
        addLog("ОШИБКА СЕРВЕРА: ${response.body}");
      }

    } catch (e) {
      addLog("КРИТИЧЕСКАЯ ОШИБКА: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DEBUG AI")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Text(logs, style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace')),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loading ? null : startHardcoreTest,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: Text(loading ? "ЖДИ..." : "ЗАПУСТИТЬ ЖЕСТКИЙ ТЕСТ"),
            )
          ],
        ),
      ),
    );
  }
}