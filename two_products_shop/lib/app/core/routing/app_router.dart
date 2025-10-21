import 'package:flutter/material.dart';

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
          _CheckoutPage(productId: args?['productId'], qty: args?['qty'] ?? 1),
        );
      case thankYou:
        final args = settings.arguments as Map<String, dynamic>?; // {orderNo}
        return _m(_ThankYouPage(orderNo: args?['orderNo'] ?? ''));
      case admin:
        return _m(const _AdminGate());
      default:
        return _m(const _NotFound());
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

class _CheckoutPage extends StatelessWidget {
  final int? productId;
  final int qty;
  const _CheckoutPage({required this.productId, required this.qty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إتمام الطلب')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            AppRouter.thankYou,
            arguments: {'orderNo': 'ORD-XXXX'},
          ),
          child: const Text('تأكيد وإظهار رقم الطلب'),
        ),
      ),
    );
  }
}

class _ThankYouPage extends StatelessWidget {
  final String orderNo;
  const _ThankYouPage({required this.orderNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شكراً لك')),
      body: Center(child: Text('رقم طلبك: $orderNo')),
    );
  }
}

class _AdminGate extends StatelessWidget {
  const _AdminGate();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('لوحة الأدمن (لاحقاً)')));
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('404')));
  }
}
