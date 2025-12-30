import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/l10n/app_localizations.dart'; 
import '../services/subscription_service.dart';
import '../services/analytics_service.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  @override
  void initState() {
    super.initState();
    // ТРЕКИНГ: Просмотр экрана оплаты
    AnalyticsService.logEvent('paywall_viewed');
  }

  @override
  Widget build(BuildContext context) {
    final subService = context.watch<SubscriptionService>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            AnalyticsService.logEvent('paywall_closed');
            Navigator.pop(context);
          },
        ),
      ),
      body: subService.isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.auto_awesome, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 24),
                  Text(
                    l10n.premium_access,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.premium_description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Spacer(),
                  
                  if (subService.products.isEmpty)
                    Text(
                      l10n.no_products,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),

                  ...subService.products.map((product) {
                    final String title = product.name ?? product.productId;
                    final String priceText = product.skProduct?.price.toString() ?? l10n.upgrade;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            // ТРЕКИНГ: Клик по кнопке покупки
                            AnalyticsService.logEvent('paywall_click_buy', {
                              'product_id': product.productId,
                              'price': product.skProduct?.price.toString() ?? 'unknown'
                            });

                            final success = await subService.purchaseProduct(product.productId);
                            
                            if (success && context.mounted) {
                              // ТРЕКИНГ: Успешная транзакция
                              AnalyticsService.logPurchase(
                                product.productId, 
                                product.skProduct?.price.toDouble() ?? 0.0, 
                                product.skProduct?.priceLocale.currencyCode ?? 'USD'
                              );
                              Navigator.pop(context);
                            } else {
                              // ТРЕКИНГ: Ошибка или отмена покупки
                              AnalyticsService.logEvent('paywall_purchase_failed', {
                                'product_id': product.productId
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple, width: 2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.deepPurple),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  priceText,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      AnalyticsService.logEvent('paywall_restore_clicked');
                      subService.restore();
                    },
                    child: Text(
                      l10n.restore_purchases, 
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}