import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/features/checkout/widgets/checkout_form.dart';
import 'package:baterfly/app/features/checkout/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../features/product/widgets/gradient_bg.dart';

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
    final price = (p['price'] as num?)?.toDouble() ?? 0.0;
    final total = price;

    return Scaffold(
      appBar: const SiteAppBar(transparent: false),
      bottomNavigationBar: const FooterLinks(),
      body: Stack(
        children: [
          const GradientBackground(),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final pad = EdgeInsets.symmetric(horizontal: w < 600 ? 16 : 24);
              final maxW = 900.0;
              final twoCols = w >= 950;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: SingleChildScrollView(
                    padding: pad.copyWith(top: 40, bottom: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العنوان
                        Row(
                          children: const [
                            Icon(
                              Icons.payment_outlined,
                              color: Color(0xFF2A82FF),
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'إتمام الشراء',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0E1A2A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),

                        // محتوى الصفحة
                        twoCols
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // تفاصيل المنتج
                                  Expanded(
                                    flex: 2,
                                    child: _OrderSummary(
                                      product: widget.product,
                                      total: total,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  // نموذج الدفع
                                  Expanded(
                                    flex: 3,
                                    child: _CheckoutCard(
                                      child: CheckoutForm(
                                        product: widget.product,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _OrderSummary(
                                    product: widget.product,
                                    total: total,
                                  ),
                                  const SizedBox(height: 28),
                                  _CheckoutCard(
                                    child: CheckoutForm(
                                      product: widget.product,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
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

/// قسم تفاصيل الطلب
class _OrderSummary extends StatelessWidget {
  final Map<String, dynamic> product;
  final double total;
  const _OrderSummary({required this.product, required this.total});

  @override
  Widget build(BuildContext context) {
    final price = (product['price'] as num?)?.toDouble() ?? 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص الطلب',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0E1A2A),
              ),
            ),
            const SizedBox(height: 16),
            ProductCardWidget(product: product),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('السعر', style: TextStyle(color: Colors.black54)),
                Text(
                  '${price.toStringAsFixed(0)} ج.م',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي الكلي',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Text(
                  '${total.toStringAsFixed(0)} ج.م',
                  style: const TextStyle(
                    color: Color(0xFF2A82FF),
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'السعر يشمل ضريبة القيمة المضافة (إن وجدت)',
              style: TextStyle(fontSize: 12.5, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة للنموذج لتبدو احترافية
class _CheckoutCard extends StatelessWidget {
  final Widget child;
  const _CheckoutCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'بيانات العميل والدفع',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0E1A2A),
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
