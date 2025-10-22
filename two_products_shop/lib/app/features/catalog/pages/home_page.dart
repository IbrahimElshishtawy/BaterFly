import 'package:flutter/material.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/animations/fade_slide.dart';
import '../../../core/widgets/animations/staggered_grid.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  int _cols(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1200) return 6;
    if (w >= 900) return 5;
    if (w >= 700) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final demo = List.generate(
      12,
      (i) => {
        'id': 'p$i',
        'title': 'منتج رقم ${i + 1}',
        'price': 'EGP ${(i + 1) * 199}',
        'image': null,
      },
    );

    return AppShell(
      onOpenCart: () {},
      onOpenSearch: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // هيرو تسويقي علوي
          FadeSlide(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(.12),
                    Theme.of(context).colorScheme.secondary.withOpacity(.10),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'عروض اليوم',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'خصومات حقيقية على أفضل المنتجات. تسوّق الآن.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.local_fire_department_outlined,
                          ),
                          label: const Text('اكتشف العروض'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // صورة ترويجية اختيارية
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(color: const Color(0xFFE9EEF5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          FadeSlide(
            delay: const Duration(milliseconds: 120),
            child: Text(
              'الأكثر مبيعًا',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 12),

          // جريد متدرّج الحركة
          Expanded(
            child: StaggeredGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _cols(context),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: .78,
              ),
              itemCount: demo.length,
              itemBuilder: (_, i) {
                final it = demo[i];
                return ProductCard(
                  id: it['id']!,
                  title: it['title']!,
                  priceText: it['price']!,
                  imageUrl: it['image'],
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (_, a, __) {
                          return FadeTransition(
                            opacity: CurvedAnimation(
                              parent: a,
                              curve: Curves.easeOutCubic,
                            ),
                            child: _ProductPageShell(productId: it['id']!),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// غلاف بسيط لفتح صفحة المنتج الموجودة لديك
class _ProductPageShell extends StatelessWidget {
  final String productId;
  const _ProductPageShell({required this.productId});
  @override
  Widget build(BuildContext context) {
    // استبدل بالمسار الفعلي لو مختلف
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const SizedBox(), // placeholder لو احتجت
      ),
    );
  }
}
