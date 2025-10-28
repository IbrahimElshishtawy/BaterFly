import 'package:baterfly/app/features/product/widgets/feature_grid.dart';
import 'package:baterfly/app/features/product/widgets/safety_list.dart';
import 'package:flutter/material.dart';
import 'section_card.dart';
import 'ingredient_chips.dart';

class RightColumn extends StatelessWidget {
  final List<String> features;
  final List<String> ingredients;
  final List<String> safety;
  const RightColumn({
    required this.features,
    required this.ingredients,
    required this.safety,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          icon: Icons.workspace_premium_outlined,
          title: 'مميزات المنتج',
          child: FeatureGrid(features),
        ),
        SectionCard(
          icon: Icons.science_outlined,
          title: 'المكوّنات',
          child: IngredientChips(ingredients),
        ),
        SectionCard(
          icon: Icons.shield_moon_outlined,
          title: 'احتياطات الأمان',
          child: SafetyList(safety),
        ),
      ],
    );
  }
}
