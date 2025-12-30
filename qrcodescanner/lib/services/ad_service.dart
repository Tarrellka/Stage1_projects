import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AdService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Тестовые ID от Google
  static String get bannerAdUnitId => 'ca-app-pub-3940256099942544/6300978111'; 
  static String get interstitialAdUnitId => 'ca-app-pub-3940256099942544/1033173712';
  
  static String get appOpenAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9257395921'
      : 'ca-app-pub-3940256099942544/5575463023';

  static InterstitialAd? _interstitialAd;
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAppOpenAd = false;
  static DateTime? _appOpenLoadTime;

  // Вспомогательный метод для логов в Firebase
  // ИСПРАВЛЕНО: Используется Map<String, Object> и латиница
  static Future<void> _logEvent(String name, Map<String, Object> params) async {
    try {
      await _analytics.logEvent(name: name, parameters: params);
      debugPrint('📊 Firebase Log: $name | $params');
    } catch (e) {
      debugPrint('⚠️ Analytics Error: $e');
    }
  }

  // --- МЕЖСТРАНИЧНАЯ РЕКЛАМА (Interstitial) ---

  static void loadInterstitial() {
    _logEvent('ad_load_request', {'ad_type': 'interstitial'});

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(), 
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _logEvent('ad_load_success', {'ad_type': 'interstitial'});
          debugPrint('✅ Interstitial Loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          _logEvent('ad_load_failed', {
            'ad_type': 'interstitial',
            'error_code': error.code.toString(),
            'error_message': error.message,
          });
          debugPrint('❌ Interstitial Failed: ${error.message}');
        },
      ),
    );
  }

  static void showInterstitial(VoidCallback onComplete) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _logEvent('ad_show_success', {'ad_type': 'interstitial'});
        },
        onAdDismissedFullScreenContent: (ad) {
          _logEvent('ad_closed', {'ad_type': 'interstitial'});
          ad.dispose();
          loadInterstitial(); 
          onComplete(); 
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _logEvent('ad_show_failed', {
            'ad_type': 'interstitial',
            'error_code': error.code.toString(),
          });
          ad.dispose();
          loadInterstitial();
          onComplete();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      _logEvent('ad_not_ready', {'ad_type': 'interstitial'});
      onComplete();
      loadInterstitial();
    }
  }

  // --- РЕКЛАМА ПРИ ОТКРЫТИИ (App Open Ad) ---

  static void loadAppOpenAd() {
    _logEvent('ad_load_request', {'ad_type': 'app_open'});

    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(), 
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          _logEvent('ad_load_success', {'ad_type': 'app_open'});
          debugPrint('✅ AppOpenAd Loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _logEvent('ad_load_failed', {
            'ad_type': 'app_open',
            'error_code': error.code.toString(),
          });
          debugPrint('❌ AppOpenAd Failed: ${error.message}');
        },
      ),
    );
  }

  static void showAppOpenAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAppOpenAd) {
      loadAppOpenAd();
      return;
    }

    // Проверка на 4 часа (срок жизни кеша Google)
    if (_appOpenLoadTime != null && 
        DateTime.now().subtract(const Duration(hours: 4)).isAfter(_appOpenLoadTime!)) {
      _logEvent('ad_expired', {'ad_type': 'app_open'});
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAppOpenAd = true;
        _logEvent('ad_show_success', {'ad_type': 'app_open'});
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpenAd = false;
        _logEvent('ad_closed', {'ad_type': 'app_open'});
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        _logEvent('ad_show_failed', {
          'ad_type': 'app_open',
          'error_code': error.code.toString(),
        });
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );
    _appOpenAd!.show();
  }
}