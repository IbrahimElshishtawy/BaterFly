// lib/app/features/catalog/widgets/product_card_widget.dart
import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool whiteText; // خليته field

  const ProductCardWidget({
    super.key,
    required this.product,
    this.whiteText = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;

    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                (p['image'] as String?) ?? 'assets/images/image_1.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BatterFly',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: whiteText ? Colors.white : Colors.black,
                    ),
                  ),

                  // const SizedBox(height: 10),
                  // Text(
                  //   '$total ج.م',
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.w800,
                  //     fontSize: 16,
                  //     color: Colors.teal,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
