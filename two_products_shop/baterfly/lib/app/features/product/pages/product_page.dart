// ignore_for_file: unnecessary_underscores, no_leading_underscores_for_local_identifiers
import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/site_app_bar.dart';
import 'package:baterfly/app/features/catalog/widgets/Search_delegate.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';
import '../../checkout/pages/checkout_page.dart';
import '../../../core/widgets/footer_links.dart';
import '../widgets/gradient_bg.dart';
import '../widgets/section_card.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String;
    final _q = ValueNotifier<String>('');

    final price = (product['price'] as num).toDouble();
    final desc = (product['desc'] ?? '') as String;
    final img =
        (product['image'] as String?) ??
        'https://via.placeholder.com/1600x900?text=Product';
    final rating = ((product['avg_rating'] ?? 0) as num).toDouble();
    final reviews = (product['reviews_count'] ?? 0) as int;
    final usage = (product['usage'] ?? '') as String;
    final features =
        (product['features'] as List?)?.cast<String>() ?? const <String>[];
    final ingredients =
        (product['ingredients'] as List?)?.cast<String>() ?? const <String>[];

    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: const [
              ListTile(
                title: Center(
                  child: Text(
                    'الأقسام',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Divider(),
              ListTile(title: Text('سياسة الاستبدال والاسترجاع')),
              ListTile(title: Text('سياسة الشحن')),
              ListTile(title: Text('التواصل مع الدعم')),
            ],
          ),
        ),
      ),
      appBar: SiteAppBar(
        transparent: false,
        onOpenMenu: () => Scaffold.of(context).openEndDrawer(),
        onSearchTap: () async {
          final res = await showSearch<String?>(
            context: context,
            delegate: CustomSearchDelegate(initial: _q.value),
          );
          if (res != null) _q.value = res;
        },
        onOpenCart: () => Navigator.pushNamed(context, '/cart'),
        onAdmin: () => Navigator.pushNamed(context, '/admin/login'),
        onLogoTap: () => Navigator.pushNamed(context, '/'),
      ),

      body: LayoutBuilder(
        builder: (context, cons) {
          final w = cons.maxWidth;
          final pad = Responsive.hpad(w);
          final maxW = Responsive.maxWidth(w);
          final heroH = Responsive.heroHeight(w);

          return Stack(
            children: [
              const GradientBackground(),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  // صورة بدون Hero
                  Responsive.wrap(
                    maxW: maxW,
                    pad: pad,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: heroH,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              img,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0x11000000),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.broken_image_outlined,
                                  size: 40,
                                  color: Colors.white70,
                                ),
                              ),
                              loadingBuilder: (ctx, child, p) => p == null
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0x22000000),
                                    Color(0x00000000),
                                    Color(0x33000000),
                                  ],
                                  stops: [0, .5, 1],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // شريط السعر + CTA
                  Responsive.wrap(
                    maxW: maxW,
                    pad: pad,
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C2D2D), Color(0xFF121313)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 12,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${Fmt.price(price)} ج.م',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber.shade400,
                                size: 22,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'التقييم:',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${rating.toStringAsFixed(1)}  ($reviews)',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: w < 560 ? double.infinity : 260,
                            height: 54,
                            child: FilledButton.icon(
                              icon: const Icon(Icons.shopping_bag_outlined),
                              label: const Text(
                                'اطلب الآن',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CheckoutPage(product: product),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // العنوان
                  Responsive.wrap(
                    maxW: maxW,
                    pad: pad,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18, bottom: 8),
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: .2,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),

                  // محتوى: عمودان ≥1024
                  if (w >= 1024)
                    Responsive.wrap(
                      maxW: maxW,
                      pad: pad,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SectionCard(
                                  icon: Icons.description_outlined,
                                  title: 'وصف المنتج',
                                  child: Text(
                                    desc.isEmpty
                                        ? 'وصف المنتج غير متوفر'
                                        : desc,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                SectionCard(
                                  icon: Icons.rule_outlined,
                                  title: 'طريقة الاستخدام',
                                  child: Text(
                                    usage.trim().isEmpty ? 'غير متوفر' : usage,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              children: [
                                SectionCard(
                                  icon: Icons.workspace_premium_outlined,
                                  title: 'مميزات المنتج',
                                  child: features.isEmpty
                                      ? const Text(
                                          'غير متوفر',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: features
                                              .map((t) => _bullet(t))
                                              .toList(),
                                        ),
                                ),
                                SectionCard(
                                  icon: Icons.science_outlined,
                                  title: 'المكونات',
                                  child: ingredients.isEmpty
                                      ? const Text(
                                          'غير متوفر',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: ingredients
                                              .map(
                                                (e) => Chip(
                                                  label: Text(e),
                                                  backgroundColor: const Color(
                                                    0x1422D1FF,
                                                  ),
                                                  side: const BorderSide(
                                                    color: Color(0x3322D1FF),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Responsive.wrap(
                      maxW: maxW,
                      pad: pad,
                      child: SectionCard(
                        icon: Icons.description_outlined,
                        title: 'وصف المنتج',
                        child: Text(
                          desc.isEmpty ? 'غير متوفر' : desc,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Responsive.wrap(
                      maxW: maxW,
                      pad: pad,
                      child: SectionCard(
                        icon: Icons.rule_outlined,
                        title: 'طريقة الاستخدام',
                        child: Text(
                          usage.trim().isEmpty ? 'غير متوفر' : usage,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Responsive.wrap(
                      maxW: maxW,
                      pad: pad,
                      child: SectionCard(
                        icon: Icons.workspace_premium_outlined,
                        title: 'مميزات المنتج',
                        child: features.isEmpty
                            ? const Text(
                                'غير متوفر',
                                style: TextStyle(color: Colors.white),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: features
                                    .map((t) => _bullet(t))
                                    .toList(),
                              ),
                      ),
                    ),
                    Responsive.wrap(
                      maxW: maxW,
                      pad: pad,
                      child: SectionCard(
                        icon: Icons.science_outlined,
                        title: 'المكونات',
                        child: ingredients.isEmpty
                            ? const Text(
                                'غير متوفر',
                                style: TextStyle(color: Colors.white),
                              )
                            : Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: ingredients
                                    .map(
                                      (e) => Chip(
                                        label: Text(e),
                                        backgroundColor: const Color(
                                          0x1422D1FF,
                                        ),
                                        side: const BorderSide(
                                          color: Color(0x3322D1FF),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  // Footer في آخر الصفحة
                  Responsive.wrap(
                    maxW: maxW,
                    pad: pad,
                    child: const FooterLinks(),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _bullet(String text) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: const [
            Icon(Icons.check_circle, size: 18, color: Color(0xFF22D1FF)),
            SizedBox(width: 8),
          ],
        ),
      )._with(
        Row(
          children: const [
            Icon(Icons.check_circle, size: 18, color: Color(0xFF22D1FF)),
            SizedBox(width: 8),
          ],
        ),
        trailing: Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      );
}

// ويدجت مساعدة صغيرة لإلحاق عنصر بعد Row ثابت
extension _WithTrailing on Widget {
  Widget _with(Widget row, {required Widget trailing}) {
    return Builder(
      builder: (_) => Row(children: [...(row as Row).children, trailing]),
    );
  }
}
