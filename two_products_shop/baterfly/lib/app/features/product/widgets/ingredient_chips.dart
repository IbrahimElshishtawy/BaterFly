import 'package:flutter/material.dart';

class IngredientChips extends StatelessWidget {
  final List<String> ingredients;
  const IngredientChips({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: ingredients.map((i) {
        return Chip(
          label: Text(i),
          backgroundColor: Colors.white.withOpacity(0.15),
          labelStyle: const TextStyle(color: Colors.white),
        );
      }).toList(),
    );
  }
}
