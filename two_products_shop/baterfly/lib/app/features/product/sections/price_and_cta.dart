import 'package:flutter/material.dart';
import '../widgets/section_card.dart';

class PriceAndCTA extends StatelessWidget {
  final Map product;
  const PriceAndCTA({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final price = product['price'] ?? 0;
    return SectionCard(
      title: "Buy Now",
      child: Column(
        children: [
          Text(
            "\$${price.toString()}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () {}, child: const Text("Add to Cart")),
        ],
      ),
    );
  }
}
