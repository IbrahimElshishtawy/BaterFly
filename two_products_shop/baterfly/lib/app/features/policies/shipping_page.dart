import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:flutter/material.dart';

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SiteAppBar(),
      bottomNavigationBar: FooterLinks(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'سياسة الشحن: يتم توصيل الطلبات خلال 2-5 أيام عمل...',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
      ),
    );
  }
}
