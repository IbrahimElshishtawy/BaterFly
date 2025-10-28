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
    // محتوى افتراضي “تجاري” عند غياب البيانات القادمة من الـ API
    final String productDesc = '''
سيرامايد من BUTTERFLY علاج احترافي غني بالبروتين والكولاجين والكافيار لإصلاح التلف ومنح قوة ولمعان فوري. مدعّم بالبيوتين والسيراميد لترطيب عميق وحماية لِبّ الشعرة، مع زيوت الأرغان وجوز الهند والأفوكادو لنعومة حريرية. خالٍ من الفورمالين ومشتقاته وآمن على جميع أنواع الشعر.
''';

    final List<String> productFeatures = [
      'إصلاح فعّال للتلف وتقصف الأطراف',
      'ترطيب عميق ولمعة فورية تدوم',
      'انسيابية ونعومة في التسريح',
      'حماية حرارية ضد أدوات التصفيف',
      'زيوت طبيعية: أرغان، جوز الهند، أفوكادو',
      'خالٍ من الفورمالين وآمن على جميع الأنواع',
    ];

    final String productUsage = '''
1) رجّي العبوة جيدًا.
2) اغسلي بالشامبو وجفّفي 80–90%.
3) قسّمي الشعر 4–6 أقسام.
4) وزّعي المنتج خصلة بخصلة ومشّطي للتوزيع.
5) اتركيه 30–45 دقيقة حسب النوع.
6) جفّفي بالسيشوار جيدًا.
7) مرّري المكواة على خصل رفيعة لتثبيت المادة.
8) اتركيه يبرد ثم اشطفي بماء بارد وجفّفي.
9) يُفضّل تجنّب الماء والربط لمدة 24 ساعة.
''';

    final List<String> productIngredients = [
      'سيراميد',
      'بروتين',
      'كولاجين',
      'مستخلص الكافيار',
    ];

    // تهيئة المحتوى النهائي
    final usedDesc = (desc).trim().isNotEmpty ? desc.trim() : productDesc;
    final usedFeatures = features.isNotEmpty ? features : productFeatures;
    final usedUsage = (usage).trim().isNotEmpty ? usage.trim() : productUsage;
    final usedIngredients = ingredients.isNotEmpty
        ? ingredients
        : productIngredients;

    final content = w >= 1024
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LeftColumn(descText: usedDesc, usageText: usedUsage),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _RightColumn(
                  features: usedFeatures,
                  ingredients: usedIngredients,
                ),
              ),
            ],
          )
        : Column(
            children: [
              _LeftColumn(descText: usedDesc, usageText: usedUsage),
              _RightColumn(
                features: usedFeatures,
                ingredients: usedIngredients,
              ),
            ],
          );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(padding: pad, child: content),
      ),
    );
  }
}

/// العمود الأيسر: وصف + طريقة الاستخدام
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
          child: _StepsList(usageText),
        ),
      ],
    );
  }
}

/// العمود الأيمن: المميزات + المكوّنات
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
          child: _FeatureList(features),
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

/// فقرة منسّقة تجاريًا
class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: const TextStyle(color: Colors.white, height: 1.7, fontSize: 15.5),
    );
  }
}

/// قائمة مميزات بعلامات تأكيد
class _FeatureList extends StatelessWidget {
  final List<String> items;
  const _FeatureList(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF22D1FF),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.6,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

/// خطوات مرقّمة تلقائيًا
class _StepsList extends StatelessWidget {
  final List<String> steps;
  _StepsList(String raw)
    : steps = raw
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .map(
            (l) => l.replaceAll(RegExp(r'^\d+\)?\s*'), ''),
          ) // ينظّف الأرقام إن وُجدت
          .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final n = i + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
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
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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

/// Chips للمكوّنات
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
            ),
          )
          .toList(),
    );
  }
}
