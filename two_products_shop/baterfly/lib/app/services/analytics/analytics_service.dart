import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  void logEvent(String name, Object map, {Map<String, dynamic>? params}) {
    if (kDebugMode) {
      debugPrint('[Analytics] Event: $name → ${params ?? {}}');
    }
  }

  void logPageView(String pageName) {
    logEvent('page_view', {'page': pageName});
  }

  void logAddToCart(String productName, double price) {
    logEvent('add_to_cart', {'product': productName, 'price': price});
  }

  void logPurchase(String orderNo, double total) {
    logEvent('purchase', {'order_no': orderNo, 'total': total});
  }
}
