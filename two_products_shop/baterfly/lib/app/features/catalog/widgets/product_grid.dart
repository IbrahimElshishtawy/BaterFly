// lib/app/features/catalog/widgets/product_grid.dart
import 'package:baterfly/app/features/catalog/widgets/product_card/animated_image_slider.dart';
import 'package:flutter/material.dart';
import 'product_card/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const ProductGrid({super.key, required this.products});

  List<String> _toImages(dynamic v) {
    if (v == null) {
      return const [
        'assets/images/image_1.jpg',
        'assets/images/image_2.jpg',
        'assets/images/image_3.jpg',
        'assets/images/image_4.jpg',
      ];
    }
    if (v is List) {
      final xs = v.map((e) => '$e'.trim()).where((e) => e.isNotEmpty).toList();
      return xs.isEmpty
          ? const [
              'assets/images/image_1.jpg',
              'assets/images/image_2.jpg',
              'assets/images/image_3.jpg',
              'assets/images/image_4.jpg',
            ]
          : xs;
    }
    final xs = '$v'
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return xs.isEmpty
        ? const [
            'assets/images/image_1.jpg',
            'assets/images/image_2.jpg',
            'assets/images/image_3.jpg',
            'assets/images/image_4.jpg',
          ]
        : xs;
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
            imageWidget: AnimatedImageSlider(images: images),
          ),
        );
      },
    );
  }
}
