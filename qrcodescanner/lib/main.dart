import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'dart:io';

import 'services/subscription_service.dart';
import 'services/analytics_service.dart';
import 'services/ad_service.dart'; 
import 'screens/scanner_screen.dart';
import 'screens/generator_screen.dart';
import 'screens/history_screen.dart';
import 'l10n/app_localizations.dart';

final ValueNotifier<int> historyUpdateNotifier = ValueNotifier<int>(0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация рекламы перед запуском приложения
  await MobileAds.instance.initialize();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("❌ Firebase error: $e");
  }

  final subService = SubscriptionService();
  runApp(
    ChangeNotifierProvider<SubscriptionService>.value(
      value: subService,
      child: const MyApp(),
    ),
  );

  _backgroundInit(subService);
}

Future<void> _backgroundInit(SubscriptionService subService) async {
  try {
    await AnalyticsService.init().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint("⚠️ Analytics error: $e");
  }
  await subService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
  int _selectedIndex = 1;
  BannerAd? _anchoredAdaptiveAd;
  bool _isAdLoaded = false;
  late StreamSubscription<AppState> _appStateSubscription;

  final List<Widget> _screens = [
    const GeneratorScreen(),
    const ScannerScreen(),
    const HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    
    // Загружаем полноэкранные форматы
    AdService.loadAppOpenAd();
    AdService.loadInterstitial();

    // Слушаем жизненный цикл для показа App Open Ad (при возврате из фона)
    AppStateEventNotifier.startListening();
    _appStateSubscription = AppStateEventNotifier.appStateStream.listen((state) {
      if (state == AppState.foreground) {
        AdService.showAppOpenAdIfAvailable();
      }
    });

    // Пробуем показать рекламу сразу после загрузки первого кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        AdService.showAppOpenAdIfAvailable();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Баннер загружается всегда (без проверок на премиум для теста)
    if (!_isAdLoaded) {
      _loadAdaptiveBanner();
    }
  }

  Future<void> _loadAdaptiveBanner() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) return;

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/9214589741'
          : 'ca-app-pub-3940256099942544/2934735716',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('❌ Banner failed: $error');
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  void dispose() {
    _anchoredAdaptiveAd?.dispose();
    _appStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
          // Показ баннера внизу
          if (_isAdLoaded && _anchoredAdaptiveAd != null)
            SafeArea(
              top: false,
              child: Container(
                color: Colors.grey[200],
                width: _anchoredAdaptiveAd!.size.width.toDouble(),
                height: _anchoredAdaptiveAd!.size.height.toDouble(),
                child: AdWidget(ad: _anchoredAdaptiveAd!),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.add_box_outlined), label: l10n.generatorTab),
          BottomNavigationBarItem(icon: const Icon(Icons.qr_code_scanner), label: l10n.scannerTab),
          BottomNavigationBarItem(icon: const Icon(Icons.history), label: l10n.historyTab),
        ],
      ),
    );
  }
}