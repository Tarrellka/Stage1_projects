import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  // Тестовые ID от Google.
  static String get bannerAdUnitId => 'ca-app-pub-3940256099942544/6300978111'; 
  static String get interstitialAdUnitId => 'ca-app-pub-3940256099942544/1033173712';

  static InterstitialAd? _interstitialAd;

  // Загрузка межстраничной рекламы (Interstitial)
  static void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial Ad Loaded');
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          debugPrint('Interstitial Ad Failed to Load: $error');
        },
      ),
    );
  }

  // Показ межстранички с коллбэком на завершение
  static void showInterstitial(VoidCallback onComplete) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitial(); // Подгружаем следующую сразу
          onComplete(); // Запускаем логику (например, AI анализ)
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitial();
          onComplete();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      // Если реклама не готова, просто идем дальше, чтобы не блокировать юзера
      onComplete();
      loadInterstitial();
    }
  }
}