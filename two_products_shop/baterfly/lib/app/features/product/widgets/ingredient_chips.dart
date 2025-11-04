import 'package:flutter/material.dart';

class IngredientChips extends StatelessWidget {
  final List<String> ingredients;

  const IngredientChips({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: ingredients
          .map(
            (ing) => Chip(
              label: Text(ing, style: const TextStyle(fontSize: 14)),
              backgroundColor: Colors.pink[50],
            ),
          )
          .toList(),
    );
  }
}
