import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_provider.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AnalyticsService {
  static late AppsflyerSdk _appsflyerSdk;

  static Future<void> init() async {
    final options = AppsFlyerOptions(
      afDevKey: "GAgckFyN4yETigBtP4qtRG",
      appId: "6749377146",
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 15,
      manualStart: true,
    );

    _appsflyerSdk = AppsflyerSdk(options);
    await _appsflyerSdk.initSdk(registerConversionDataCallback: true);

    // Обработка данных конверсии
    _appsflyerSdk.onInstallConversionData((result) async {
      final uid = await _appsflyerSdk.getAppsFlyerUID();
      final status = result['status'];
      
      try {
        final payload = Map<String, dynamic>.from(result['payload'] as Map);
        final dynamic apphudStatic = Apphud;

        if (status == 'success') {
          await apphudStatic.addAttribution(
            provider: ApphudAttributionProvider.appsFlyer,
            data: payload,
            identifier: uid,
          );
        } else {
          await apphudStatic.addAttribution(
            provider: ApphudAttributionProvider.appsFlyer,
            identifier: uid,
            data: {'error': payload['data'] ?? 'failed'},
          );
        }
      } catch (e) {
        debugPrint("Attribution error: $e");
      }
    });

    if (Platform.isIOS) {
      await _requestATT();
    }

    _appsflyerSdk.startSDK();

    await AppMetrica.activate(
      const AppMetricaConfig("9aa14141-e964-494e-b91e-560073bac3a7"),
    );
  }

  // --- МЕТОД ДЛЯ ТРЕКИНГА СОБЫТИЙ ---
  static void logEvent(String name, [Map<String, dynamic>? params]) {
    // 1. В AppsFlyer
    _appsflyerSdk.logEvent(name, params ?? {});
    
    // 2. В AppMetrica 
    AppMetrica.reportEvent(name);
    
    debugPrint("📊 [Analytics] Event: $name | Params: $params");
  }

  static Future<void> _requestATT() async {
    try {
      var status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        status = await AppTrackingTransparency.requestTrackingAuthorization();
      }
      debugPrint("ATT Status: $status");
    } catch (e) {
      debugPrint("ATT Error: $e");
    }
  }

  static Future<String?> getAppsFlyerId() async {
    return await _appsflyerSdk.getAppsFlyerUID();
  }
}