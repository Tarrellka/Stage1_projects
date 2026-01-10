import 'dart:io';
import 'package:apphud/apphud.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import '../core/config.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_provider.dart';

class AnalyticsService extends ChangeNotifier {
  late AppsflyerSdk _appsflyerSdk;
  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;

  Future<void> init() async {
    // 1. Инициализация AppHud
    await Apphud.start(apiKey: AppConfig.appHudApiKey);
    await checkSubscriptionStatus();

    // 2. Настройка AppsFlyer
    AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: AppConfig.appsFlyerDevKey,
      appId: AppConfig.appleAppId,
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 60,
    );

    _appsflyerSdk = AppsflyerSdk(options);

    // 3. Запрос ATT (iOS)
    if (Platform.isIOS) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    // 4. Инициализация SDK и установка колбэка для атрибуции
    _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
    );

    _appsflyerSdk.onInstallConversionData((data) {
      debugPrint("AppsFlyer Conversion Data: $data");
      
      Apphud.setAttribution(
        data: data,
        provider: ApphudAttributionProvider.appsFlyer,
      );
    });
  }

  // Проверка премиум-доступа
  Future<void> checkSubscriptionStatus() async {
    _isSubscribed = await Apphud.hasPremiumAccess();
    notifyListeners();
  }

  // Покупка продукта
  Future<bool> purchaseProduct(String productId) async {
    final result = await Apphud.purchase(productId: productId);
    if (result.subscription?.isActive ?? false) {
      _isSubscribed = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Восстановление покупок
  Future<void> restorePurchases() async {
    await Apphud.restorePurchases();
    await checkSubscriptionStatus();
  }
}