import 'package:flutter/material.dart';

class USPBar extends StatelessWidget {
  final List<String> points;
  const USPBar({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      color: Colors.white.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: points.map((p) {
          return Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 5),
              Text(p, style: const TextStyle(color: Colors.white)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
