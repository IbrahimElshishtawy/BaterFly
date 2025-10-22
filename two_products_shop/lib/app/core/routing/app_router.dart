import 'package:flutter/material.dart';
import '../../features/catalog/pages/home_page.dart';
import '../../features/product/pages/product_page.dart';
import '../../features/checkout/pages/checkout_page.dart';
import '../../features/checkout/pages/thank_you_page.dart';
import '../../features/admin/pages/admin_dashboard_page.dart';

class AppRouter {
  static const String home = '/';
  static const String product = '/p';
  static const String checkout = '/checkout';
  static const String thankYou = '/thank-you';
  static const String admin = '/admin';

  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _m(const HomePage());
      case product:
        final args = settings.arguments as Map?;
        final product = args?['product'] as Map<String, dynamic>? ?? {};
        final slug = args?['slug'] as String? ?? '';
        return _m(ProductPage(product: product, slug: slug));
      case checkout:
        final id = (settings.arguments as Map?)?['productId'] as int? ?? 0;
        return _m(CheckoutPage(productId: id));
      case thankYou:
        final no = (settings.arguments as Map?)?['orderNo'];
        return _m(ThankYouPage(orderNo: no));
      case admin:
        return _m(const AdminDashboardPage());
      default:
        return _m(const Scaffold(body: Center(child: Text('404'))));
    }
  }

  static MaterialPageRoute _m(Widget c) => MaterialPageRoute(builder: (_) => c);
}
