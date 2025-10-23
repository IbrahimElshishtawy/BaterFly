import 'package:flutter/material.dart';
import '../widgets/feature_list.dart';
import '../widgets/usage_section.dart';
import '../../reviews/widgets/review_section.dart';

class ProductPageShell extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductPageShell({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final features =
        (product['features'] as List?)?.cast<String>() ?? const <String>[];
    final usage = product['usage'] as String?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeatureList(features: features),
        const SizedBox(height: 14),
        UsageSection(usage: usage),
        const SizedBox(height: 24),
        ReviewSection(productId: product['id'] as int),
      ],
    );
  }
}
