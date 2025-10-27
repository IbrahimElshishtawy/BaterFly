// lib/app/features/product/widgets/product_title.dart
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final String name;

  const ProductTitle({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        name,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: .2,
          color: Colors.white,
        ),
      ),
    );
  }
}
