import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final Map<String, dynamic> product;
  final int quantity;
  const OrderSummary({super.key, required this.product, this.quantity = 1});

  @override
  Widget build(BuildContext context) {
    final price = (product['price'] as num).toDouble();
    final total = price * quantity;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product['image'],
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text('الكمية: $quantity'),
                ],
              ),
            ),
            Text(
              '${total.toStringAsFixed(2)} ج.م',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
