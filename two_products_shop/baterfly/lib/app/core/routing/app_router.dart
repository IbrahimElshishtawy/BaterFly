import 'package:flutter/material.dart';
import '../../features/catalog/pages/home_page.dart';

class AppRouter {
  static Route<dynamic> onGenerate(RouteSettings s) {
    switch (s.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
