import 'package:flutter/material.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(18),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: .75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (_, val, child) => Opacity(
            opacity: val,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - val)),
              child: child,
            ),
          ),
          child: ProductCard(
            name: p['name'],
            price: p['price'],
            image: p['image'],
            onTap: p['onTap'],
          ),
        );
      },
    );
  }
}
