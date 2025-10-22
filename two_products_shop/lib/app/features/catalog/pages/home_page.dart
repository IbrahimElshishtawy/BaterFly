// ignore_for_file: unnecessary_cast
import 'package:flutter/material.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/animations/fade_slide.dart';
import '../../product/pages/product_page_shell.dart';
import '../../../data/datasources/remote/products_remote.dart';
import '../../../data/models/product_model.dart';
import '../../product/widgets/product_list_item.dart';
import '../../../core/utils/formatters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _remote = ProductsRemote();
  late Future<List<ProductModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _remote.fetchActive(limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      onOpenCart: () {},
      onOpenSearch: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 16),
          FadeSlide(
            delay: const Duration(milliseconds: 120),
            child: Text(
              'الأكثر مبيعًا',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _future,
              builder: (context, s) {
                if (s.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (s.hasError) return Center(child: Text('خطأ: ${s.error}'));
                final items = s.data ?? [];
                if (items.isEmpty)
                  return const Center(child: Text('لا توجد منتجات حالياً'));

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return ProductListItem(
                      id: p.id,
                      title: p.title,
                      priceText: Formatters.money(p.displayPrice),
                      imageUrl: p.imageUrl,
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 400,
                            ),
                            pageBuilder: (_, a, __) => FadeTransition(
                              opacity: CurvedAnimation(
                                parent: a,
                                curve: Curves.easeOutCubic,
                              ),
                              child: ProductPageShell(productId: p.id),
                            ),
                          ),
                        );
                      },
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
