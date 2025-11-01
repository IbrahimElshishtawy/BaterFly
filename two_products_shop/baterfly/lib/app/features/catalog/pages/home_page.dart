// ignore_for_file: unused_import, unused_local_variable

import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/product_video_widget.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/catalog/widgets/Search_delegate.dart';
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

  List<String> _toImages(dynamic v) {
    const fallback = [
      'assets/images/image_1.jpg',
      'assets/images/image_2.jpg',
      'assets/images/image_3.jpg',
      'assets/images/image_4.jpg',
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

  // 🎬 كارت فيديو مخصص
  Widget _buildVideoCard(String videoUrl, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            ProductVideoWidget(videoUrl: videoUrl),
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              // 🔍 شريط البحث
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

                            return CustomScrollView(
                              slivers: [
                                // 🏷️ إعلان
                                SliverToBoxAdapter(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: maxW,
                                      ),
                                      child: Padding(
                                        padding: pad,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            top: 14,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0x14FFFFFF),
                                                Color(0x0F000000),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            border: Border.all(
                                              color: Color(0x22FFFFFF),
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
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 8),
                                ),

                                // 🛒 المنتجات
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
                                      final m = items[i];
                                      final images = _toImages(m['images']);
                                      final price = (m['price'] as num?)
                                          ?.toDouble();
                                      final rating =
                                          ((m['avg_rating'] ?? 0) as num?)
                                              ?.toDouble();

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
                                        ),
                                      );
                                    }, childCount: items.length),
                                  ),
                                ),

                                // 🎬 قسم الفيديوهات - متجاوب
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 30,
                                    ),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final isWide =
                                            constraints.maxWidth > 900;
                                        final videos = [
                                          {
                                            'url': 'assets/video/video_1.mp4',
                                            'label': 'تجربة العملاء ❤️',
                                          },
                                          {
                                            'url': 'assets/video/video_2.mp4',
                                            'label': 'مراجعة المنتج 🔥',
                                          },
                                          {
                                            'url': 'assets/video/video_3.mp4',
                                            'label': 'آراء المستخدمين 🌟',
                                          },
                                        ];

                                        return Center(
                                          child: Container(
                                            width: isWide
                                                ? constraints.maxWidth * 0.85
                                                : double.infinity,
                                            child: isWide
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: videos.map((v) {
                                                      return Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child:
                                                              _buildVideoCard(
                                                                v['url']!,
                                                                v['label']!,
                                                              ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  )
                                                : SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: videos.map((v) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                              ),
                                                          child: SizedBox(
                                                            width:
                                                                constraints
                                                                    .maxWidth *
                                                                0.85,
                                                            child:
                                                                _buildVideoCard(
                                                                  v['url']!,
                                                                  v['label']!,
                                                                ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                // ⚙️ الفوتر
                                SliverToBoxAdapter(
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.only(
                                      top: 24,
                                      bottom: 32,
                                    ),
                                    child: const FooterLinks(),
                                  ),
                                ),

                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 12),
                                ),
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
