// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:baterfly/app/data/models/product_model.dart';

import '../widgets/ingredient_chips.dart';
import '../widgets/usage_accordion.dart';
import '../widgets/safety_list.dart';
import '../widgets/trust_row.dart';
import '../widgets/section_card.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 700;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.all(isWeb ? 32 : 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Column(
                children: [
                  SectionCard(
                    title: "أهم المميزات",
                    transparent: true,
                    content: _buildBullets(product.mainBenefits),
                  ),

                  IngredientChips(ingredients: product.ingredients),

                  UsageAccordion(steps: product.usage),

                  SafetyList(items: product.safety),

                  SectionCard(
                    title: "مميزات إضافية",
                    transparent: true,
                    content: _buildBullets(product.highlights, icon: "✨"),
                  ),

                  const TrustRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBullets(List<String> list, {String icon = "•"}) {
    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "$icon $item",
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
