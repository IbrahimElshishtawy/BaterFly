// lib/app/features/catalog/widgets/product_card/dots.dart
// ignore_for_file: unused_element, file_names, deprecated_member_use

import 'package:flutter/material.dart';

class Dots extends StatelessWidget {
  final int count;
  final int index;
  const Dots({super.key, required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: i == index ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(i == index ? .95 : .45),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
