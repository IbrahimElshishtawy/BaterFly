import 'package:baterfly/app/features/product/widgets/section_card.dart';
import 'package:baterfly/app/features/product/widgets/ingredient_chips.dart';
import 'package:baterfly/app/features/product/widgets/left_column.dart';
import 'package:baterfly/app/features/product/widgets/right_column.dart';
import 'package:baterfly/app/features/product/widgets/safety_list.dart';
import 'package:baterfly/app/features/product/widgets/trust_row.dart';
import 'package:baterfly/app/features/product/widgets/usage_accordion.dart';
import 'package:baterfly/app/features/product/widgets/usp_bar.dart';
import 'package:flutter/material.dart';

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
        : '''
1. يتم غسل الشعر جيدًا قبل الاستخدام
2. تجفيف الشعر بنسبة 80% بواسطة منشفة دافئة وواساخ ساخن.
3. تقسيم الشعر من 4–6 أجزاء حسب مناسبيته.
4. توزيع المنتج خصلة خصلة.
5. تركه لمدة 30–45 دقيقة حسب نوع الشعر.
6. جفف الشعر بواسطة السيشوار.
7. مرري المكواة على الخصلات الرفيعة.
8. شطفه بماء بارد.
''';

    final safety = const [
      'اختبار حساسية على خصلة صغيرة قبل الاستخدام الأول.',
      'تجنب ملامسة العينين والجلد المتهيج.',
      'يُستخدم على شعر نظيف فقط.',
      'مخصص للاستخدام الخارجي فقط.',
    ];

    final wide = w >= 1100;

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
              if (wide)
                _WideSplit(
                  left: LeftColumn(descText: usedDesc, usageText: productUsage),
                  right: RightColumn(
                    features: features,
                    ingredients: ingredients,
                    safety: safety,
                  ),
                )
              else
                _Tabbed(
                  tabs: const ['الوصف', 'الاستخدام', 'المكوّنات', 'الأمان'],
                  views: [
                    SectionCard(
                      icon: Icons.description_outlined,
                      title: 'وصف المنتج',
                      child: Text(usedDesc),
                    ),
                    SectionCard(
                      icon: Icons.rule_outlined,
                      title: 'طريقة الاستخدام',
                      child: UsageAccordion(text: productUsage),
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideSplit extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _WideSplit({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        Container(
          width: 1,
          height: 520,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          color: const Color(0x22FFFFFF),
        ),
        Expanded(child: right),
      ],
    );
  }
}

class _Tabbed extends StatelessWidget {
  final List<String> tabs;
  final List<Widget> views;
  const _Tabbed({required this.tabs, required this.views});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0x111E2A3C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x22FFFFFF)),
            ),
            child: TabBar(
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              indicator: BoxDecoration(
                color: const Color(0x1A22D1FF),
                borderRadius: BorderRadius.circular(999),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFFB9C6D3),
              tabs: tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(height: 640, child: TabBarView(children: views)),
        ],
      ),
    );
  }
}
