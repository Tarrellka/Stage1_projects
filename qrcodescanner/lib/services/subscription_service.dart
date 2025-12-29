import 'package:flutter/material.dart';
import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_product.dart';
import 'dart:async';

class SubscriptionService with ChangeNotifier {
  final String apiKey = "app_Z44sHCCXqhP5FCBDa8SxKBLB7VLpga";
  
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitialized = false; // Флаг для предотвращения повторного запуска

  List<ApphudProduct> _products = [];
  List<ApphudProduct> get products => _products;

  Future<void> init() async {
    if (_isInitialized) return;

    _isLoading = false; 
  
    unawaited(_reallyInitApphud());
  }

  Future<void> _reallyInitApphud() async {
    try {
      // Даем приложению 2 секунды полностью прогрузить UI
      await Future.delayed(const Duration(seconds: 2));

      await Apphud.start(apiKey: apiKey);
      _isInitialized = true;

      // Проверяем статус и пэйволлы
      _isPremium = await Apphud.hasPremiumAccess();
      
      final paywallsResult = await Apphud.paywallsDidLoadCallback();
      if (paywallsResult.paywalls.isNotEmpty) {
        final mainPaywall = paywallsResult.paywalls.firstWhere(
          (p) => p.identifier == "main_paywall",
          orElse: () => paywallsResult.paywalls.first,
        );
        _products = mainPaywall.products ?? [];
      }
      
      debugPrint("✅ Apphud: готов");
      notifyListeners(); // Обновит экран, когда данные придут
    } catch (e) {
      debugPrint("⚠️ Apphud Background Error: $e");
    }
  }

  Future<bool> purchaseProduct(String productId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await Apphud.purchase(productId: productId);
      if (result.subscription?.isActive ?? false) {
        _isPremium = true;
        return true;
      }
    } catch (e) {
      debugPrint("❌ Ошибка покупки: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> restore() async {
    _isLoading = true;
    notifyListeners();
    try {
      _isPremium = await Apphud.hasPremiumAccess();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}