import 'package:flutter/material.dart';

class UsageSection extends StatelessWidget {
  final String? usage;
  const UsageSection({super.key, this.usage});

  @override
  Widget build(BuildContext context) {
    if (usage == null || usage!.trim().isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'طريقة الاستخدام',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          usage!,
          textAlign: TextAlign.start,
          style: const TextStyle(height: 1.5),
        ),
      ],
    );
  }
}
