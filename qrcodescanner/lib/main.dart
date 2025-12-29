import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Добавлено для рекламы
import 'dart:async';

// Твои импорты сервисов и экранов
import 'services/subscription_service.dart';
import 'services/analytics_service.dart';
import 'screens/scanner_screen.dart';
import 'screens/generator_screen.dart';
import 'screens/history_screen.dart';
import 'l10n/app_localizations.dart';

// ГЛОБАЛЬНАЯ ПЕРЕМЕННАЯ (нужна для result_controller.dart)
final ValueNotifier<int> historyUpdateNotifier = ValueNotifier<int>(0);

void main() async {
  // 1. Инициализация движка Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 1.5. Инициализация рекламы (запускаем сразу в фоне)
  unawaited(MobileAds.instance.initialize());

  // 2. БЛОКИРУЮЩАЯ инициализация Firebase
  try {
    await Firebase.initializeApp();
    debugPrint("✅ Firebase успешно запущен");
  } catch (e) {
    debugPrint("❌ Ошибка запуска Firebase: $e");
  }

  final subService = SubscriptionService();

  runApp(
    ChangeNotifierProvider<SubscriptionService>.value(
      value: subService,
      child: const MyApp(),
    ),
  );

  // 3. Догружаем тяжелые сервисы в фоне
  _backgroundInit(subService);
}

Future<void> _backgroundInit(SubscriptionService subService) async {
  try {
    await AnalyticsService.init().timeout(const Duration(seconds: 5));
    debugPrint("✅ Аналитика готова");
  } catch (e) {
    debugPrint("⚠️ Ошибка аналитики: $e");
  }
  
  // Инициализация покупок (Apphud)
  await subService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Поддержка языков
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Настройка темы
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // По умолчанию открыт сканер (центр)
  BannerAd? _bannerAd; // Переменная для рекламного баннера

  final List<Widget> _screens = [
    const GeneratorScreen(),
    const ScannerScreen(),
    const HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Начинаем загрузку баннера сразу при старте
    _loadBanner();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Тестовый ID баннера Google
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Рекламный баннер загружен");
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Ошибка загрузки рекламы: $error");
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Обязательно освобождаем память
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Следим за статусом подписки через Provider
    final isPremium = context.watch<SubscriptionService>().isPremium;
    
    return Scaffold(
      body: Column(
        children: [
          // Основной контент экрана
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
          
          // РЕКЛАМНЫЙ БЛОК: Показываем только если нет премиума и реклама готова
          if (!isPremium && _bannerAd != null)
            SafeArea(
              top: false,
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_box_outlined), 
            label: l10n.generatorTab
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code_scanner), 
            label: l10n.scannerTab
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history), 
            label: l10n.historyTab
          ),
        ],
      ),
    );
  }
}