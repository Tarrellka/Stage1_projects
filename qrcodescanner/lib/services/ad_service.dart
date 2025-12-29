import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AdService {
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

  // --- МЕЖСТРАНИЧНАЯ РЕКЛАМА (Interstitial) ---

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

  static void showInterstitial(VoidCallback onComplete) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitial(); 
          onComplete(); 
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
      onComplete();
      loadInterstitial();
    }
  }

  // --- РЕКЛАМА ПРИ ОТКРЫТИИ (App Open Ad) ---

  static void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(), 
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          debugPrint('AppOpenAd Loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd Failed to Load: $error');
        },
      ),
    );
  }

  static void showAppOpenAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAppOpenAd) {
      loadAppOpenAd();
      return;
    }

    if (_appOpenLoadTime != null && 
        DateTime.now().subtract(const Duration(hours: 4)).isAfter(_appOpenLoadTime!)) {
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAppOpenAd = true,
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );
    _appOpenAd!.show();
  }
}