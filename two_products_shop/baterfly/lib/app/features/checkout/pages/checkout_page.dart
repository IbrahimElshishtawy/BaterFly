// lib/app/features/catalog/pages/checkout_page.dart
import 'package:baterfly/app/features/checkout/widgets/checkout_form.dart';
import 'package:baterfly/app/features/checkout/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../features/product/widgets/gradient_bg.dart';
import '../../../core/widgets/footer_links/footer_links.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final price = (p['price'] as num).toDouble();
    final total = price * 1;

    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: const [
              ListTile(title: Text('سياسة الاستبدال والاسترجاع')),
              ListTile(title: Text('سياسة الشحن')),
              ListTile(title: Text('التواصل مع الدعم')),
            ],
          ),
        ),
      ),
      appBar: const SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final pad = EdgeInsets.symmetric(horizontal: 24);
              final maxW = 700.0;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: ListView(
                    padding: pad.copyWith(top: 40, bottom: 40),
                    children: [
                      ProductCardWidget(product: widget.product),
                      const SizedBox(height: 24),
                      CheckoutForm(product: widget.product),
                      const SizedBox(height: 50),
                      const FooterLinks(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
