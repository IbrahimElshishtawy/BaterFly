import 'package:flutter/material.dart';

class FeatureList extends StatelessWidget {
  final List<String> features;
  const FeatureList({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('المميزات', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ...features.map(
          (f) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(f)),
            ],
          ),
        ),
      ],
    );
  }
}
