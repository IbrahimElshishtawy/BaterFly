import 'package:flutter/material.dart';

class FeatureList extends StatelessWidget {
  final List<String> features;
  const FeatureList({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
            (f) => Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(f)),
              ],
            ),
          )
          .toList(),
    );
  }
}
