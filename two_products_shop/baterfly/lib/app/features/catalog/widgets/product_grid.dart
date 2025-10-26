import 'package:flutter/material.dart';
import 'product_card/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const ProductGrid({super.key, required this.products});

  List<String> _toImages(dynamic v) {
    if (v == null)
      return const ['https://via.placeholder.com/800x1000?text=Product'];
    if (v is List) {
      return v.map((e) => '$e'.trim()).where((e) => e.isNotEmpty).toList();
    }
    // يدعم "a.jpg, b.jpg"
    return '$v'
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

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
        final images = _toImages(p['images'] ?? p['image']);
        final price = (p['price'] as num?)?.toDouble();
        final rating = (p['rating'] as num?)?.toDouble();

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
            images: images,
            price: price,
            rating: rating,
            // إن احتجت onTap أو name أضفها في ProductCard نفسه ثم مررها هنا
          ),
        );
      },
    );
  }
}
