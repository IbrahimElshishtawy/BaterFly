// lib/app/features/product/widgets/price_and_cta.dart
import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class PriceAndCTA extends StatelessWidget {
  final double price;
  final double rating;
  final int reviews;
  final VoidCallback onTap;

  const PriceAndCTA({
    super.key,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C2D2D), Color(0xFF121313)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 12,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${Fmt.price(price)} ج.م',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.star_rounded, color: Colors.amber.shade400, size: 22),
              const SizedBox(width: 4),
              const Text(
                'التقييم:',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(width: 6),
              Text(
                '${rating.toStringAsFixed(1)}  ($reviews)',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          SizedBox(
            width: 260,
            height: 54,
            child: FilledButton.icon(
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('اطلب الآن', style: TextStyle(fontSize: 18)),
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
