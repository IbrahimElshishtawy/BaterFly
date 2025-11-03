// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/features/catalog/widgets/product_card/animated_image_slider.dart';
import 'package:baterfly/app/features/catalog/widgets/widget/build_video_Section.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/responsive.dart';
import '../../../core/widgets/footer_links/footer_links.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../services/supabase/supabase_service.dart';
import '../../product/widgets/gradient_bg.dart';
import '../../product/widgets/product_hover.dart';
import '../widgets/product_card/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final SupabaseClient _sb;
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..forward();

  @override
  void initState() {
    super.initState();
    _sb = Supa.client;
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await _sb
        .from('products')
        .select('id,name,slug,price,avg_rating,reviews_count,active')
        .eq('active', true)
        .order('reviews_count', ascending: false)
        .order('avg_rating', ascending: false)
        .limit(60);

    return (rows as List).cast<Map<String, dynamic>>();
  }

  /// 🔹 صور محلية من assets
  List<String> _localImages() {
    return const [
      'assets/images/image_1.jpg',
      'assets/images/image_2.jpg',
      'assets/images/image_3.jpg',
      'assets/images/image_4.jpg',
    ];
  }

  /// 🔹 ترجع مجموعة صور لكل منتج (هيتبدلوا بشكل انيميشن)
  List<String> _getProductImages(int index) {
    final imgs = _localImages();
    return [
      imgs[index % imgs.length],
      imgs[(index + 1) % imgs.length],
      imgs[(index + 2) % imgs.length],
    ];
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
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _load(),
            builder: (context, s) {
              if (s.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
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
                      /// 🏷️ العنوان الرئيسي
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            'BatteryFly',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      /// 🔹 الجزء الأول من المنتجات
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(side, 16, side, 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: .78,
                              ),
                          delegate: SliverChildBuilderDelegate((context, i) {
                            if (i >= midIndex) return null;
                            final m = items[i];
                            final images = _getProductImages(i);
                            final price = (m['price'] as num?)?.toDouble();
                            final rating = ((m['avg_rating'] ?? 0) as num?)
                                ?.toDouble();

                            return ProductHover(
                              child: ProductCard(
                                // ✅ استبدال الصورة بالأنيميشن
                                images: images,
                                price: price,
                                rating: rating,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/product',
                                    arguments: {...m, 'images': images},
                                  );
                                },
                                imageWidget: AnimatedImageSlider(
                                  images: images,
                                ),
                              ),
                            );
                          }, childCount: midIndex),
                        ),
                      ),

                      /// 🎥 قسم الفيديوهات
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: BuildVideoSection(),
                        ),
                      ),

                      /// 💄 الجزء الثاني من المنتجات
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(side, 16, side, 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: .78,
                              ),
                          delegate: SliverChildBuilderDelegate((context, i) {
                            final index = midIndex + i;
                            if (index >= items.length) return null;
                            final m = items[index];
                            final images = _getProductImages(index);
                            final price = (m['price'] as num?)?.toDouble();
                            final rating = ((m['avg_rating'] ?? 0) as num?)
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
                                    arguments: {...m, 'images': images},
                                  );
                                },
                                imageWidget: AnimatedImageSlider(
                                  images: images,
                                ),
                              ),
                            );
                          }, childCount: items.length - midIndex),
                        ),
                      ),

                      /// ⚙️ الفوتر
                      const SliverToBoxAdapter(child: FooterLinks()),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
