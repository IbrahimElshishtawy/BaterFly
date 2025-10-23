import 'package:flutter/material.dart';
import '../../features/catalog/pages/home_page.dart';
import '../../features/product/pages/product_page.dart';
import '../../features/checkout/pages/checkout_page.dart';
import '../../features/admin/auth/admin_login_page.dart';
import '../../features/admin/pages/admin_dashboard_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerate(RouteSettings s) {
    switch (s.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.product:
        final p = s.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => ProductPage(product: p));
      case AppRoutes.checkout:
        final p = s.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => CheckoutPage(product: p));
      case AppRoutes.adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginPage());
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
