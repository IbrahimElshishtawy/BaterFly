// ignore_for_file: unused_import, unused_local_variable, deprecated_member_use

import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/product_video_widget.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/catalog/widgets/Search_delegate.dart';
import 'package:baterfly/app/features/catalog/widgets/widget/build_video_Section.dart';
import 'package:baterfly/app/features/product/widgets/product_hover.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/widgets/footer_links/footer_links.dart';
import '../../../services/supabase/supabase_service.dart';
import '../../product/widgets/gradient_bg.dart';
import '../widgets/product_card/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final SupabaseClient _sb;
  final _q = ValueNotifier<String>('');
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..forward();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sb = Supa.client;
    _searchController.addListener(() {
      _q.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await _sb
        .from('products')
        .select('id,name,slug,price,images,avg_rating,reviews_count,active')
        .eq('active', true)
        .order('reviews_count', ascending: false)
        .order('avg_rating', ascending: false)
        .limit(60);
    final list = (rows as List).cast<Map<String, dynamic>>();
    final q = _q.value.trim();
    if (q.isEmpty) return list;
    return list.where((m) {
      final name = (m['name'] ?? '').toString();
      final slug = (m['slug'] ?? '').toString();
      return name.toLowerCase().contains(q.toLowerCase()) ||
          slug.toLowerCase().contains(q.toLowerCase());
    }).toList();
  }

  // 🔹 تعديل مسارات الصور
  List<String> _toImages(dynamic v) {
    const fallback = [
      'assets/products/product1.jpg',
      'assets/products/product2.jpg',
      'assets/products/product3.jpg',
      'assets/products/product4.jpg',
    ];
    if (v == null) return fallback;
    if (v is List) {
      final xs = v.map((e) => '$e'.trim()).where((e) => e.isNotEmpty).toList();
      return xs.isEmpty ? fallback : xs;
    }
    final xs = '$v'
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return xs.isEmpty ? fallback : xs;
  }

  int _cols(double w) {
    if (w >= 1600) return 6;
    if (w >= 1300) return 5;
    if (w >= 992) return 4;
    if (w >= 720) return 3;
    if (w >= 520) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن منتج...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: _q,
                  builder: (context, query, _) {
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _load(),
                      builder: (context, s) {
                        if (s.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final items = s.data ?? const [];

                        return LayoutBuilder(
                          builder: (_, c) {
                            final w = c.maxWidth;
                            final pad = Responsive.hpad(w);
                            final maxW = Responsive.maxWidth(w);
                            final cols = _cols(w);
                            double side = (w - maxW) / 2;
                            final minSide = pad.horizontal / 2;
                            if (side < minSide) side = minSide;

                            final midIndex = (items.length / 2).floor();

                            return CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: const Text(
                                      '🛍️ أفضل العروض لهذا الأسبوع!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),

                                // المنتجات الأولى
                                SliverPadding(
                                  padding: EdgeInsets.fromLTRB(
                                    side,
                                    16,
                                    side,
                                    16,
                                  ),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: cols,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16,
                                          childAspectRatio: .78,
                                        ),
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      i,
                                    ) {
                                      if (i >= midIndex) return null;
                                      final m = items[i];
                                      final images = _toImages(m['images']);
                                      final price = (m['price'] as num?)
                                          ?.toDouble();
                                      final rating =
                                          ((m['avg_rating'] ?? 0) as num?)
                                              ?.toDouble();

                                      return ProductHover(
                                        child: ProductCard(
                                          images: images,
                                          price: price,
                                          rating: rating,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/product',
                                              arguments: {
                                                ...m,
                                                'images': images,
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    }, childCount: midIndex),
                                  ),
                                ),

                                // 🎞️ قسم الفيديوهات المعدّل
                                SliverToBoxAdapter(
                                  child: LayoutBuilder(
                                    builder: (_, c) => buildVideoSection(c),
                                  ),
                                ),

                                // المنتجات التانية
                                SliverPadding(
                                  padding: EdgeInsets.fromLTRB(
                                    side,
                                    16,
                                    side,
                                    16,
                                  ),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: cols,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16,
                                          childAspectRatio: .78,
                                        ),
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      i,
                                    ) {
                                      final index = midIndex + i;
                                      if (index >= items.length) return null;
                                      final m = items[index];
                                      final images = _toImages(m['images']);
                                      final price = (m['price'] as num?)
                                          ?.toDouble();
                                      final rating =
                                          ((m['avg_rating'] ?? 0) as num?)
                                              ?.toDouble();

                                      return ProductHover(
                                        child: ProductCard(
                                          images: images,
                                          price: price,
                                          rating: rating,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/product',
                                              arguments: {
                                                ...m,
                                                'images': images,
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    }, childCount: items.length - midIndex),
                                  ),
                                ),

                                // الفوتر
                                const SliverToBoxAdapter(child: FooterLinks()),
                              ],
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
        ],
      ),
    );
  }
}
