import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/catalog/pages/home_page.dart';
import '../../features/product/pages/product_page.dart';
import '../../features/checkout/pages/checkout_page.dart';
import '../../features/checkout/pages/thank_you_page.dart';
import '../../features/admin/pages/admin_dashboard_page.dart';
import '../../features/admin/pages/orders_page.dart';
import '../../features/admin/pages/reviews_page.dart';
import '../../features/admin/pages/settings_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings s) {
    switch (s.name) {
      case Routes.home:
        return _m(const HomePage());
      case Routes.product:
        final slug = (s.arguments as Map?)?['slug'] as String? ?? '';
        return _m(ProductPage(slug: slug));
      case Routes.checkout:
        final id = (s.arguments as Map?)?['productId'] as int? ?? 0;
        return _m(CheckoutPage(productId: id));
      case Routes.thankYou:
        final no = (s.arguments as Map?)?['orderNo'];
        return _m(ThankYouPage(orderNo: no));
      case Routes.admin:
        return _m(const AdminDashboardPage());
      case Routes.adminOrders:
        return _m(const OrdersPage());
      case Routes.adminReviews:
        return _m(const AdminReviewsPage());
      case Routes.adminSettings:
        return _m(const AdminSettingsPage());
      default:
        return _m(const Scaffold(body: Center(child: Text('404'))));
    }
  }

  static MaterialPageRoute _m(Widget c) => MaterialPageRoute(builder: (_) => c);
}
