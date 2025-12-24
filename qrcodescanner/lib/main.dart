import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/scanner_screen.dart';
import 'screens/history_screen.dart';
import 'screens/generator_screen.dart';

// Глобальный уведомлятель для обновления истории
final ValueNotifier<int> historyUpdateNotifier = ValueNotifier<int>(0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Читаем параметры базы из db.txt
    final dbContent = await rootBundle.loadString('assets/db.txt');
    final dbLines = dbContent.split('\n').map((e) => e.trim()).where((s) => s.isNotEmpty).toList();

    if (dbLines.length >= 2) {
      await Supabase.initialize(
        url: dbLines[0],      // Первая строка: URL Supabase
        anonKey: dbLines[1],  // Вторая строка: Anon Key
      );
      print("БАЗА ДАННЫХ: Подключено успешно");
    } else {
      print("ОШИБКА: В assets/db.txt должно быть 2 строки (URL и Key)");
    }
  } catch (e) {
    print("ОШИБКА ИНИЦИАЛИЗАЦИИ БД: $e");
  }

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

  final List<Widget> _screens = [
    const ScannerScreen(),
    const GeneratorScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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