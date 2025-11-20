import 'package:flutter/material.dart';

import 'package:baterfly/app/core/widgets/site_app_bar/search_page.dart';
import 'package:baterfly/app/features/Track/ui/Track_Product_Page.dart';
import 'package:baterfly/app/features/Track/ui/order_details_page.dart';

import 'package:baterfly/app/features/cart/pages/cart_page.dart';
import 'package:baterfly/app/features/contact/pages/contact_page.dart';
import 'package:baterfly/app/features/policies/pages/returns_page.dart';
import 'package:baterfly/app/features/policies/pages/support_page.dart';
import 'package:baterfly/app/features/policies/pages/shipping_page.dart';

import 'package:baterfly/app/features/catalog/pages/home_page.dart';
import 'package:baterfly/app/features/product/pages/product_page.dart';
import 'package:baterfly/app/features/checkout/pages/checkout_page.dart';
import 'package:baterfly/app/features/admin/auth/admin_login_page.dart';
import 'package:baterfly/app/features/admin/pages/admin_dashboard_page.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerate(RouteSettings s) {
    switch (s.name) {
      // الصفحة الرئيسية
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      // سياسة الاستبدال والاسترجاع
      case AppRoutes.returns:
        return MaterialPageRoute(builder: (_) => const ReturnsPage());

      // سياسة الشحن
      case AppRoutes.shipping:
        return MaterialPageRoute(builder: (_) => const ShippingPage());

      // صفحة الدعم
      case AppRoutes.support:
        return MaterialPageRoute(builder: (_) => const SupportPage());

      // الكاتالوج (حالياً نفس الهوم)
      case AppRoutes.catalog:
        return MaterialPageRoute(builder: (_) => const HomePage());

      // صفحة المنتج
      case AppRoutes.product:
        {
          final args = s.arguments as Map<String, dynamic>?;
          final slug = (args?['slug'] as String?) ?? 'ceramide-butterfly';

          return MaterialPageRoute(builder: (_) => ProductPage(slug: slug));
        }

      // صفحة إتمام الشراء
      case AppRoutes.checkout:
        {
          final args = s.arguments;
          Map<String, dynamic> productArgs = {};
          if (args != null && args is Map<String, dynamic>) {
            productArgs = args;
          }

          return MaterialPageRoute(
            builder: (_) => CheckoutPage(product: productArgs['product']),
          );
        }

      // دخول الأدمن
      case AppRoutes.adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginPage());

      // لوحة تحكم الأدمن
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardPage());

      // اتصل بنا
      case AppRoutes.contact:
        return MaterialPageRoute(builder: (_) => const ContactPage());

      // سلة المشتريات
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());

      // تتبع الطلبات بالاسم
      case AppRoutes.track:
        return MaterialPageRoute(builder: (_) => const TrackProductPage());

      // صفحة البحث العامة
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());

      // صفحة تفاصيل الطلب
      case AppRoutes.orderDetails:
        {
          // نتوقع أن الـ arguments يكون int (رقم الطلب)
          final orderId = s.arguments as int?;

          if (orderId == null) {
            // في حالة عدم إرسال رقم الطلب
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('No order ID provided')),
              ),
            );
          }

          return MaterialPageRoute(
            builder: (_) => OrderDetailsPage(orderId: orderId),
            settings: s,
          );
        }

      // رووت غير معروف
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
