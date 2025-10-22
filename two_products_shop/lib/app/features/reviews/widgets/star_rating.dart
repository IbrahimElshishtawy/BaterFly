import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int value; // 0..5
  final double size;
  final void Function(int newValue)? onChanged;
  const StarRating({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < value;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: size,
          icon: Icon(Icons.star, color: filled ? Colors.amber : Colors.grey),
          onPressed: onChanged == null ? null : () => onChanged!(i + 1),
        );
      }),
    );
  }
}
