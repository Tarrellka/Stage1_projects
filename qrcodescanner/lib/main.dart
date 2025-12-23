import 'package:flutter/material.dart';
import 'screens/scanner_screen.dart';
import 'screens/history_screen.dart';
import 'screens/generator_screen.dart';

// Глобальный уведомлятель для обновления истории при переключении вкладок
final ValueNotifier<int> historyUpdateNotifier = ValueNotifier<int>(0);

void main() {
  runApp(const QRCodeScannerApp());
}

class QRCodeScannerApp extends StatelessWidget {
  const QRCodeScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI QR Scanner Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      home: const MainHolder(),
    );
  }
}

class MainHolder extends StatefulWidget {
  const MainHolder({super.key});

  @override
  State<MainHolder> createState() => _MainHolderState();
}

class _MainHolderState extends State<MainHolder> {
  int _selectedIndex = 0;

  // Список всех экранов приложения
  final List<Widget> _screens = [
    const ScannerScreen(),
    const GeneratorScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack сохраняет состояние страниц (камера не выключается при переходе)
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          // Если переходим на вкладку Истории (теперь она под индексом 2),
          // отправляем сигнал на обновление данных
          if (index == 2) {
            historyUpdateNotifier.value++;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_rounded),
            selectedIcon: Icon(Icons.qr_code_scanner),
            label: 'Сканер',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Создать',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history),
            label: 'История',
          ),
        ],
      ),
    );
  }
}