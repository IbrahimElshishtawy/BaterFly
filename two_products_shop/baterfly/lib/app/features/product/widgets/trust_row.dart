import 'package:flutter/material.dart';

class TrustRow extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const TrustRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 16,
        runSpacing: 10,
        children: items.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item['icon'], color: Colors.white, size: 30),
              const SizedBox(height: 5),
              Text(item['label'], style: const TextStyle(color: Colors.white)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
