// ignore_for_file: unused_import

import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/catalog/widgets/Search_delegate.dart';
import 'package:baterfly/app/features/product/widgets/product_hover.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/widgets/footer_links/footer_links.dart';
import '../../../services/supabase/supabase_service.dart';
import '../../product/widgets/gradient_bg.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String initialQuery});
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
      return name.contains(q) || slug.contains(q);
    }).toList();
  }

  int _cols(double w) {
    if (w >= 1400) return 6;
    if (w >= 1200) return 5;
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

      // استخدم شريط الموقع بدل AppBar الافتراضي
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

                  // حواف جانبية لتوسيط الشبكة داخل maxW مع احترام padding
                  double side = (w - maxW) / 2;
                  final minSide = pad.horizontal / 2;
                  if (side < minSide) side = minSide;

                  return CustomScrollView(
                    slivers: [
                      // شريط ترويجي علوي
                      SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxW),
                            child: Padding(
                              padding: pad,
                              child: Container(
                                margin: const EdgeInsets.only(top: 14),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0x14FFFFFF),
                                      Color(0x0F000000),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: const Color(0x22FFFFFF),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.local_shipping_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'شحن سريع واسترجاع خلال 14 يوم',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 8)),

                      // الشبكة
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
                            final m = items[i];
                            final imgs =
                                (m['images'] as List?)?.cast() ?? const [];
                            final img = imgs.isNotEmpty
                                ? imgs.first.toString()
                                : 'https://via.placeholder.com/800x1000?text=Product';

                            return FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _ac,
                                curve: Interval(
                                  i / (items.length + 1),
                                  1,
                                  curve: Curves.easeOut,
                                ),
                              ),
                              child: ProductHover(
                                child: ProductCard(
                                  name: m['name'],
                                  price: (m['price'] as num).toDouble(),
                                  rating: ((m['avg_rating'] ?? 0) as num)
                                      .toDouble(),
                                  image: img,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/product',
                                      arguments: {...m, 'image': img},
                                    );
                                  },
                                ),
                              ),
                            );
                          }, childCount: items.length),
                        ),
                      ),

                      // Footer
                      SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxW),
                            child: Padding(
                              padding: pad,
                              child: const FooterLinks(),
                            ),
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
