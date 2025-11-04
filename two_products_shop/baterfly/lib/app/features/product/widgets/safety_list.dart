import 'package:flutter/material.dart';

class SafetyList extends StatelessWidget {
  final List<String> items;

  const SafetyList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "⚠️ تعليمات الأمان:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "• $item",
                style: const TextStyle(fontSize: 15, height: 1.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
