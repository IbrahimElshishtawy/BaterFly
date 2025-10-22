// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:two_products_shop/app/features/product/pages/product_page_shell.dart';
import 'package:two_products_shop/app/features/product/widgets/product_list_item.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/animations/fade_slide.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                          onPressed: () {
                            // تعامل مع الضغط هنا
                          },
                          icon: const Icon(
                            Icons.local_fire_department_outlined,
                          ),
                          label: const Text('اكتشف العروض'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
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

          // قائمة منتجات أفقية بدلاً من الجريد
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: demo.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final it = demo[i];
                return ProductListItem(
                  id: it['id'] as String,
                  title: it['title'] as String,
                  priceText: it['price'] as String,
                  imageUrl: it['image'] as String?,
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, a, __) => FadeTransition(
                          opacity: CurvedAnimation(
                            parent: a,
                            curve: Curves.easeOutCubic,
                          ),
                          child: ProductPageShell(
                            productId: it['id'] as String,
                          ),
                        ),
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
