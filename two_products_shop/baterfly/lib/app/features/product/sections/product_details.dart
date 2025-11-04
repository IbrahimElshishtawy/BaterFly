import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import '../widgets/usage_accordion.dart';
import '../widgets/safety_list.dart';

class ProductDetails extends StatelessWidget {
  final Map product;
  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: "Description",
          child: Text(product['description'] ?? 'No description available.'),
        ),
        UsageAccordion(usage: product['usage']),
        SafetyList(items: product['safety'] ?? []),
      ],
    );
  }
}
