import 'package:flutter/material.dart';

class IngredientChips extends StatelessWidget {
  final List<String> items;
  const IngredientChips(this.items);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map((e) {
          return Chip(
            label: Text(e),
            backgroundColor: const Color(0x14222A3A),
            side: const BorderSide(color: Color(0x33FFFFFF)),
            labelStyle: const TextStyle(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }).toList(),
      ),
    );
  }
}
