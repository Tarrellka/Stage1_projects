import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static late AppsflyerSdk _appsflyerSdk;
  static final FirebaseAnalytics _firebase = FirebaseAnalytics.instance;

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

    _appsflyerSdk.onInstallConversionData((result) async {
      final status = result['status'];
      
      try {
        if (status == 'success' && result['payload'] != null) {
          // Здесь была атрибуция Apphud
          debugPrint("AppsFlyer Conversion Success: ${result['payload']}");
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

  static void logPurchase(String productId, double price, String currency) {
    _firebase.logPurchase(
      currency: currency,
      value: price,
      items: [AnalyticsEventItem(itemId: productId, itemName: productId)],
    );
  
    logEvent('purchase_success', {
      'product_id': productId, 
      'price': price, 
      'currency': currency
    });
  }

  static void logEvent(String name, [Map<String, dynamic>? params]) {
    final Map<String, Object>? firebaseParams = params?.map((key, value) => MapEntry(key, value as Object));
    _firebase.logEvent(name: name, parameters: firebaseParams);

    _appsflyerSdk.logEvent(name, params ?? {});
    AppMetrica.reportEvent(name); 
    
    debugPrint("📊 [Analytics] Event: $name | Params: $params");
  }

  static Future<void> _requestATT() async {
    try {
      var status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        status = await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      debugPrint("ATT Error: $e");
    }
  }

  static Future<String?> getAppsFlyerId() async {
    return await _appsflyerSdk.getAppsFlyerUID();
  }
}