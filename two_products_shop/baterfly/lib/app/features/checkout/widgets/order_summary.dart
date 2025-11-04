import 'package:baterfly/app/features/checkout/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final Map<String, dynamic> product;
  final double total;
  const OrderSummary({super.key, required this.product, required this.total});

  @override
  Widget build(BuildContext context) {
    final price = (product['price'] as num?)?.toDouble() ?? 0.0;

    return Card(
      color: Colors.white.withOpacity(0.1),
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ProductCardWidget(product: product, whiteText: true),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('السعر', style: TextStyle(color: Colors.white70)),
                Text(
                  '${price.toStringAsFixed(0)} ج.م',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Divider(color: Colors.white30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي الكلي',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
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
              style: TextStyle(fontSize: 12.5, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
