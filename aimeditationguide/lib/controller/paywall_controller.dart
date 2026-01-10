import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_paywall.dart';
import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../core/config.dart';

class PaywallController extends ChangeNotifier {
  final AnalyticsService analyticsService;
  ApphudPaywall? _paywall;
  bool isLoading = true;

  PaywallController(this.analyticsService) {
    _initPaywall();
  }

  Future<void> _initPaywall() async {
    try {

      final result = await Apphud.fetchPlacements();
      

      if (result.placements.isNotEmpty) {
        _paywall = result.placements.first.paywall;
      } else {
        final paywallsResult = await Apphud.rawPaywalls();
        if (paywallsResult != null && paywallsResult.paywalls.isNotEmpty) {
          _paywall = paywallsResult.paywalls.firstWhere(
            (pw) => pw.identifier == AppConfig.mainPaywallId,
            orElse: () => paywallsResult.paywalls.first,
          );
        }
      }
    } catch (e) {
      debugPrint("Ошибка инициализации: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  String getPrice(String planId, String defaultPrice) {
    if (_paywall == null || _paywall!.products == null) return defaultPrice;
    
    try {
      final product = _paywall!.products!.firstWhere(
        (p) => p.productId.contains(planId),
        orElse: () => _paywall!.products!.first,
      );
      final price = product.skProduct?.price;
      final symbol = product.skProduct?.priceLocale.currencySymbol ?? "\$";
      return price != null ? "$symbol$price" : defaultPrice;
    } catch (_) {
      return defaultPrice;
    }
  }

  Future<bool> purchase(String planId) async {
    if (_paywall == null || _paywall!.products == null) return false;
    
    final product = _paywall!.products!.firstWhere(
      (p) => p.productId.contains(planId)
    );


    final result = await Apphud.purchase(product: product);
    return result.subscription?.isActive ?? false;
  }
}