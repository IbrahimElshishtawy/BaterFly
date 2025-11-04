import 'package:flutter/material.dart';

class RightColumn extends StatelessWidget {
  final String title;
  final String subtitle;
  final double price;
  final VoidCallback onBuy;

  const RightColumn({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 15),
        Text(
          "\$${price.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: onBuy, child: const Text("Buy Now")),
      ],
    );
  }
}
