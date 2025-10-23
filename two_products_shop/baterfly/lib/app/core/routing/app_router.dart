import 'package:flutter/material.dart';
import '../../features/catalog/pages/home_page.dart';
import '../../features/product/pages/product_page.dart';
import '../../features/checkout/pages/checkout_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.product:
        final p = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => ProductPage(product: p));
      case AppRoutes.checkout:
        final p = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => CheckoutPage(product: p));
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page Not Found'))),
        );
    }
  }
}
