import 'package:baterfly/app/features/Track/ui/Track_Product_Page.dart';
import 'package:flutter/material.dart';
import 'package:baterfly/app/features/cart/pages/cart_page.dart';
import 'package:baterfly/app/features/contact/pages/contact_page.dart';
import 'package:baterfly/app/features/policies/pages/returns_page.dart';
import 'package:baterfly/app/features/policies/pages/support_page.dart';
import 'package:baterfly/app/features/policies/pages/shipping_page.dart';

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

      case AppRoutes.returns:
        return MaterialPageRoute(builder: (_) => const ReturnsPage());

      case AppRoutes.shipping:
        return MaterialPageRoute(builder: (_) => const ShippingPage());

      case AppRoutes.support:
        return MaterialPageRoute(builder: (_) => const SupportPage());

      case AppRoutes.catalog:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.product:
        {
          final args = s.arguments as Map<String, dynamic>?;
          final slug = (args?['slug'] as String?) ?? 'ceramide-butterfly';
          return MaterialPageRoute(builder: (_) => ProductPage(slug: slug));
        }

      case AppRoutes.checkout:
        final args = s.arguments;
        Map<String, dynamic> productArgs = {};
        if (args != null && args is Map<String, dynamic>) {
          productArgs = args;
        }

        return MaterialPageRoute(
          builder: (_) => CheckoutPage(product: productArgs['product']),
        );

      case AppRoutes.adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginPage());

      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardPage());

      case AppRoutes.contact:
        return MaterialPageRoute(builder: (_) => const ContactPage());

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case AppRoutes.track:
        return MaterialPageRoute(builder: (_) => const TrackProductPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
