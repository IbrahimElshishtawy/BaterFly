import 'package:flutter/material.dart';
import 'package:two_products_shop/app/features/catalog/pages/home_page.dart';
import 'package:two_products_shop/app/features/checkout/pages/checkout_page.dart';
import 'package:two_products_shop/app/features/checkout/pages/thank_you_page.dart';

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
        final args = settings.arguments as Map<String, dynamic>?; // {slug}
        return _m(_ProductPage(slug: args?['slug'] ?? ''));
      case checkout:
        final args =
            settings.arguments as Map<String, dynamic>?; // {productId, qty}
        return _m(
          CheckoutPage(productId: args?['productId'], qty: args?['qty'] ?? 1),
        );
      case thankYou:
        final args = settings.arguments as Map<String, dynamic>?; // {orderNo}
        return _m(ThankYouPage(orderNo: args?['orderNo'] ?? ''));
      case admin:
        return _m(const AdminGate());
      default:
        return _m(const NotFound());
    }
  }

  static MaterialPageRoute _m(Widget c) => MaterialPageRoute(builder: (_) => c);
}

class _ProductPage extends StatelessWidget {
  final String slug;
  const _ProductPage({required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('منتج: $slug')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تفاصيل المنتج + تقييمات'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.checkout,
                arguments: {'productId': 1, 'qty': 1},
              ),
              child: const Text('اطلب الآن'),
            ),
          ],
        ),
      ),
    );
  }
}
