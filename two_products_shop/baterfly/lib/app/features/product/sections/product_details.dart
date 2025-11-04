import 'package:baterfly/app/data/static/product_data.dart';
import 'package:flutter/material.dart';

import '../widgets/ingredient_chips.dart';
import '../widgets/usage_accordion.dart';
import '../widgets/safety_list.dart';
import '../widgets/trust_row.dart';
import '../widgets/section_card.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: "أهم المميزات",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ProductData.mainBenefits
                .map(
                  (b) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "• $b",
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        IngredientChips(ingredients: ProductData.ingredients),
        UsageAccordion(steps: ProductData.usage),
        SafetyList(items: ProductData.safety),
        SectionCard(
          title: "مميزات إضافية",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ProductData.highlights
                .map((h) => Text("✨ $h", style: const TextStyle(fontSize: 16)))
                .toList(),
          ),
        ),
        const TrustRow(),
      ],
    );
  }
}
