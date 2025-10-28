import 'package:flutter/material.dart';
import 'section_card.dart';
import 'usage_accordion.dart';

class LeftColumn extends StatelessWidget {
  final String descText;
  final String usageText;
  const LeftColumn({
    super.key,
    required this.descText,
    required this.usageText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          icon: Icons.description_outlined,
          title: 'وصف المنتج',
          child: Text(descText),
        ),
        SectionCard(
          icon: Icons.rule_outlined,
          title: 'طريقة الاستخدام',
          child: UsageAccordion(text: usageText),
        ),
      ],
    );
  }
}
