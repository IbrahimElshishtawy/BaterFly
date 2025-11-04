import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final Map product;
  const ProductTitle({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        product['name'] ?? 'Unnamed Product',
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
