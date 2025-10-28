// lib/app/features/product/widgets/product_details.dart
import 'package:baterfly/app/features/product/widgets/section_card.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final double w;
  final double maxW;
  final EdgeInsets pad;
  final String desc;
  final String usage;
  final List<String> features;
  final List<String> ingredients;
  final VoidCallback onAddToCart; // جديد

  const ProductDetails({
    super.key,
    required this.w,
    required this.maxW,
    required this.pad,
    required this.desc,
    required this.usage,
    required this.features,
    required this.ingredients,
    required this.onAddToCart, // جديد
  });

  @override
  Widget build(BuildContext context) {
    const String productDesc = '''
سيرامايد BUTTERFLY علاج احترافي غني بالبروتين والكولاجين والكافيار لإصلاح التلف ومنح لمعان فوري. مدعّم بالبيوتين والسيراميد لترطيب عميق وحماية لُبّ الشعرة، مع زيوت الأرغان وجوز الهند والأفوكادو لنعومة حريرية. خالٍ من الفورمالين وآمن على جميع أنواع الشعر.
''';

    final List<String> productFeatures = features.isNotEmpty
        ? features
        : [
            'إصلاح فعّال للتلف وتقصف الأطراف',
            'ترطيب عميق ولمعان يدوم',
            'انسيابية ونعومة في التسريح',
            'حماية حرارية ضد أدوات التصفيف',
            'زيوت طبيعية: أرغان، جوز الهند، أفوكادو',
            'خالٍ من الفورمالين وآمن على جميع الأنواع',
          ];

    final String productUsage = usage.trim().isNotEmpty
        ? usage.trim()
        : 'رجّي العبوة جيدًا. اغسلي بالشامبو وجفّفي 80–90%. قسّمي الشعر 4–6 أقسام. وزّعي المنتج خصلة بخصلة ومشّطي. اتركيه 30–45 دقيقة حسب النوع. جفّفي بالسيشوار. مرّري المكواة على خصل رفيعة. اتركيه يبرد ثم اشطفي بماء بارد وجفّفي. يُفضّل تجنّب الماء والربط لمدة 24 ساعة.';

    final List<String> productIngredients = ingredients.isNotEmpty
        ? ingredients
        : ['سيراميد', 'بروتين', 'كولاجين', 'مستخلص الكافيار'];

    final usedDesc = desc.trim().isNotEmpty ? desc.trim() : productDesc;

    final content = w >= 1100
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LeftColumn(descText: usedDesc, usageText: productUsage),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _RightColumn(
                  features: productFeatures,
                  ingredients: productIngredients,
                ),
              ),
            ],
          )
        : Column(
            children: [
              _LeftColumn(descText: usedDesc, usageText: productUsage),
              _RightColumn(
                features: productFeatures,
                ingredients: productIngredients,
              ),
            ],
          );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(
          padding: pad,
          child: Column(
            children: [
              _USPBar(),
              const SizedBox(height: 12),
              const _TrustRow(),
              const SizedBox(height: 18),
              content,
              const SizedBox(height: 24),
              _CTABanner(onAddToCart: onAddToCart), // تعديل
            ],
          ),
        ),
      ),
    );
  }
}

class _USPBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.flash_on_outlined, 'نتيجة فورية'),
      (Icons.health_and_safety_outlined, 'آمن بدون فورمالين'),
      (Icons.opacity_outlined, 'ترطيب عميق'),
      (Icons.bolt_outlined, 'تقوية الألياف'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1C2E), Color(0xFF13243C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x2233C7FF)),
      ),
      child: LayoutBuilder(
        builder: (_, c) {
          final isTight = c.maxWidth < 600;
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 10,
            spacing: 18,
            children: items
                .map(
                  (e) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(e.$1, size: 18, color: const Color(0xFF22D1FF)),
                      const SizedBox(width: 8),
                      Text(
                        e.$2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTight ? 12.5 : 13.5,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow();

  @override
  Widget build(BuildContext context) {
    Widget item(IconData ic, String t, [String? sub]) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(ic, size: 18, color: const Color(0xFF9BE8FF)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (sub != null)
              Text(
                sub,
                style: const TextStyle(
                  color: Color(0xFFB9C6D3),
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0x101ED4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x2233C7FF)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 12,
        spacing: 22,
        children: [
          item(Icons.star_rate_rounded, 'تقييم 4.9/5', '+1,200 مراجعة'),
          item(Icons.verified_user_outlined, 'ضمان استرجاع', '14 يومًا'),
          item(Icons.local_shipping_outlined, 'شحن سريع', '2–5 أيام عمل'),
        ],
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  final String descText;
  final String usageText;
  const _LeftColumn({required this.descText, required this.usageText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          icon: Icons.description_outlined,
          title: 'وصف المنتج',
          child: _Paragraph(descText),
        ),
        SectionCard(
          icon: Icons.rule_outlined,
          title: 'طريقة الاستخدام',
          child: _UsageAccordion(text: usageText),
        ),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  final List<String> features;
  final List<String> ingredients;
  const _RightColumn({required this.features, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          icon: Icons.workspace_premium_outlined,
          title: 'مميزات المنتج',
          child: _FeatureGrid(features),
        ),
        SectionCard(
          icon: Icons.science_outlined,
          title: 'المكونات',
          child: _IngredientChips(ingredients),
        ),
      ],
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.trim(),
      textAlign: TextAlign.start,
      style: const TextStyle(color: Colors.white, height: 1.75, fontSize: 15.5),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final List<String> items;
  const _FeatureGrid(this.items);

  @override
  Widget build(BuildContext context) {
    final twoCols = MediaQuery.sizeOf(context).width > 520;
    return LayoutBuilder(
      builder: (_, __) {
        final cross = twoCols ? 2 : 1;
        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 5,
          ),
          itemBuilder: (_, i) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0x0F22D1FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x2222D1FF)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF22D1FF),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      items[i],
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.4,
                        fontSize: 14.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _UsageAccordion extends StatefulWidget {
  final String text;
  const _UsageAccordion({required this.text});

  @override
  State<_UsageAccordion> createState() => _UsageAccordionState();
}

class _UsageAccordionState extends State<_UsageAccordion> {
  bool open = true;

  List<String> _steps(String raw) => raw
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .map((l) => l.replaceAll(RegExp(r'^\d+\)?\s*'), ''))
      .toList();

  @override
  Widget build(BuildContext context) {
    final steps = _steps(widget.text);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x2233C7FF)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => open = !open),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.toc, color: Color(0xFF9BE8FF)),
                  SizedBox(width: 8),
                  Text(
                    'عرض/إخفاء الخطوات',
                    style: TextStyle(color: Colors.white, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),
          if (open) const Divider(color: Color(0x2233C7FF), height: 1),
          if (open)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: List.generate(steps.length, (i) {
                  final n = i + 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepBadge(n: n),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: const TextStyle(
                              color: Colors.white,
                              height: 1.6,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  final int n;
  const _StepBadge({required this.n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF22D1FF).withOpacity(.18),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0x3322D1FF)),
      ),
      child: Text(
        '$n',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _IngredientChips extends StatelessWidget {
  final List<String> items;
  const _IngredientChips(this.items);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items
          .map(
            (e) => Chip(
              label: Text(e),
              backgroundColor: const Color(0x1422D1FF),
              side: const BorderSide(color: Color(0x3322D1FF)),
              labelStyle: const TextStyle(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CTABanner extends StatelessWidget {
  final VoidCallback onAddToCart; // جديد
  const _CTABanner({required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E1A2A), Color(0xFF0F2B4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x2233C7FF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard_outlined, color: Color(0xFF22D1FF)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'احصلي على شعر أقوى ولمعان فوري مع سيرامايد BUTTERFLY. أضيفيه للسلة الآن.',
              style: TextStyle(color: Colors.white, fontSize: 14.5),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              onAddToCart(); // إضافة للسلة أولاً
              Navigator.of(context).pushNamed('/checkout'); // ثم الانتقال
            },
            icon: const Icon(Icons.shopping_bag_outlined, size: 18),
            label: const Text('أضف للسلة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22D1FF),
              foregroundColor: const Color(0xFF0A1220),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
