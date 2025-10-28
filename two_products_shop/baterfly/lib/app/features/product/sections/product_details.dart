import 'package:baterfly/app/features/product/widgets/left_column.dart';
import 'package:baterfly/app/features/product/widgets/right_column.dart';
import 'package:baterfly/app/features/product/widgets/trust_row.dart';
import 'package:baterfly/app/features/product/widgets/usp_bar.dart';
import 'package:flutter/material.dart';
import 'package:baterfly/app/features/product/widgets/section_card.dart';

class ProductDetails extends StatelessWidget {
  final double w;
  final double maxW;
  final EdgeInsets pad;
  final String desc;
  final String usage;
  final List<String> features;
  final List<String> ingredients;

  const ProductDetails({
    super.key,
    required this.w,
    required this.maxW,
    required this.pad,
    required this.desc,
    required this.usage,
    required this.features,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    final usedDesc = desc.trim().isNotEmpty
        ? desc.trim()
        : 'سيرامايد BUTTERFLY ...';
    final productUsage = usage.trim().isNotEmpty
        ? usage.trim()
        : 'رجّي العبوة جيدًا ...';

    final safety = const [
      'اختبار حساسية على خصلة صغيرة قبل الاستخدام الأول.',
      'تجنّب ملامسة العينين والجلد المتهيج.',
      'يُستخدم على شعر نظيف فقط ...',
      'مخصّص للاستخدام الخارجي فقط.',
    ];

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(
          padding: pad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const USPBar(),
              const SizedBox(height: 12),
              const TrustRow(),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LeftColumn(
                      descText: usedDesc,
                      usageText: productUsage,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: RightColumn(
                      features: features,
                      ingredients: ingredients,
                      safety: safety,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
