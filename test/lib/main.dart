import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// --- КЛАСС ТОЛЬКО С ТЕСТОВЫМИ ID ---
class AdHelper {
  static String get bannerAdUnitId => 'ca-app-pub-3940256099942544/6300978111';
  static String get interstitialAdUnitId => 'ca-app-pub-3940256099942544/1033173712';
  static String get rewardedAdUnitId => 'ca-app-pub-3940256099942544/5224354917';
  static String get appOpenAdUnitId => 'ca-app-pub-3940256099942544/9257395915';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация с настройкой тестовых устройств (помогает в Release APK)
  final initStatus = await MobileAds.instance.initialize();
  
  // Если ты видишь свой ID в логах, вставь его в этот список
  RequestConfiguration configuration = RequestConfiguration(testDeviceIds: []);
  await MobileAds.instance.updateRequestConfiguration(configuration);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const AdMobFullPage(),
    );
  }
}

class AdMobFullPage extends StatefulWidget {
  const AdMobFullPage({super.key});

  @override
  State<AdMobFullPage> createState() => _AdMobFullPageState();
}

class _AdMobFullPageState extends State<AdMobFullPage> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  AppOpenAd? _appOpenAd;

  bool _isBannerLoaded = false; // Флаг для безопасного отображения
  String _status = "Тестовый режим активен 🛠️";

  // --- БАННЕР ---
  void _loadBanner() {
    setState(() {
      _isBannerLoaded = false;
      _status = "⏳ Загрузка баннера...";
    });

    _bannerAd?.dispose();
    
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerLoaded = true;
            _status = "✅ Тестовый баннер загружен";
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          setState(() {
            _isBannerLoaded = false;
            _status = "❌ Ошибка: ${err.message}";
          });
          print('Banner error: ${err.message}');
        },
      ),
    );

    _bannerAd!.load();
  }

  // --- МЕЖСТРАНИЧНАЯ ---
  void _loadInterstitial() {
    setState(() => _status = "⏳ Загрузка Interstitial...");
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _showInterstitial();
        },
        onAdFailedToLoad: (err) => setState(() => _status = "❌ Ошибка: ${err.message}"),
      ),
    );
  }

  void _showInterstitial() {
    if (_interstitialAd == null) return;
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        setState(() => _status = "🏠 Реклама закрыта");
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // --- ВИДЕО С НАГРАДОЙ ---
  void _loadRewarded() {
    setState(() => _status = "⏳ Загрузка Rewarded...");
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _showRewarded();
        },
        onAdFailedToLoad: (err) => setState(() => _status = "❌ Ошибка: ${err.message}"),
      ),
    );
  }

  void _showRewarded() {
    if (_rewardedAd == null) return;
    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      setState(() => _status = "🎁 Награда: ${reward.amount} (Тест)");
    });
    _rewardedAd = null;
  }

  // --- APP OPEN ---
  void _loadAppOpen() {
    setState(() => _status = "⏳ Загрузка App Open...");
    AppOpenAd.load(
      adUnitId: AdHelper.appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.show();
          setState(() => _status = "✅ App Open показан");
        },
        onAdFailedToLoad: (err) => setState(() => _status = "❌ Ошибка: ${err.message}"),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _appOpenAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AdMob Fixed Build')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(_status, textAlign: TextAlign.center),
                    ),
                    _adButton('Загрузить Баннер', _loadBanner),
                    _adButton('Межстраничная (Interstitial)', _loadInterstitial),
                    _adButton('Видео с наградой (Rewarded)', _loadRewarded),
                    _adButton('Реклама открытия (App Open)', _loadAppOpen),
                  ],
                ),
              ),
            ),
          ),
          // БАННЕР: Рисуем ТОЛЬКО если _isBannerLoaded == true
          if (_bannerAd != null && _isBannerLoaded)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }

  Widget _adButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: 280,
        child: ElevatedButton(onPressed: onPressed, child: Text(title)),
      ),
    );
  }
}