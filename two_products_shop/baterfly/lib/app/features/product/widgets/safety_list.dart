import 'package:flutter/material.dart';

class SafetyList extends StatelessWidget {
  final List items;
  const SafetyList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Safety Information",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...items.map(
            (item) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(item.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
