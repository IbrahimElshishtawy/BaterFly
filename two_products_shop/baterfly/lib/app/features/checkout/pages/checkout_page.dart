import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/features/checkout/widgets/Checkout_Card.dart';
import 'package:baterfly/app/features/checkout/widgets/checkout_form.dart';
import 'package:baterfly/app/features/checkout/widgets/order_summary.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../features/product/widgets/gradient_bg.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic>? product;
  const CheckoutPage({super.key, this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // ============ دالة الريفرش ============
  Future<void> _refresh() async {
    // لو حابب بعدين تجيب بيانات المنتج من API حط النداء هنا
    setState(() {});
    // اختيارية: بس عشان يبان الانيميشن شويّة
    await Future.delayed(const Duration(milliseconds: 300));
  }
  // =====================================

  @override
  Widget build(BuildContext context) {
    final p = widget.product ?? {};
    final price = (p['price'] as num?)?.toDouble() ?? 0.0;
    final total = price;

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: const SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: LayoutBuilder(
                          builder: (context, c) {
                            final w = c.maxWidth;
                            final twoCols = w >= 950;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // العنوان
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.payment_outlined,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'إتمام الشراء',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 26),

                                // محتوى الصفحة
                                twoCols
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: OrderSummary(
                                              product: p,
                                              total: total,
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            flex: 3,
                                            child: CheckoutCard(
                                              child: CheckoutForm(product: p),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          OrderSummary(
                                            product: p,
                                            total: total,
                                          ),
                                          const SizedBox(height: 28),
                                          CheckoutCard(
                                            child: CheckoutForm(product: p),
                                          ),
                                        ],
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Footer كـ Sliver
                const SliverToBoxAdapter(child: FooterLinks()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
