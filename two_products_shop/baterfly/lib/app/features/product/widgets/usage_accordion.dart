import 'package:flutter/material.dart';

class UsageAccordion extends StatelessWidget {
  final List<String> steps;

  const UsageAccordion({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("📋 طريقة الاستخدام"),
      children: steps
          .map(
            (s) => ListTile(
              title: Text(s, style: const TextStyle(fontSize: 15, height: 1.3)),
            ),
          )
          .toList(),
    );
  }
}
