import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/widgets/app_footer.dart';
import '../../../services/supabase/supabase_service.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final SupabaseClient _sb;
  late final TextEditingController _search;
  late final AnimationController _ac;
  late final Animation<double> _fade;
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _sb = Supa.client;
    _search = TextEditingController();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _fetch();
  }

  @override
  void dispose() {
    _ac.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _fetch([String q = '']) async {
    setState(() => _loading = true);

    // ابقِ البناء على FilterBuilder ثم اطلب order في النهاية
    final fb = _sb.from('products').select().eq('active', true);
    if (q.trim().isNotEmpty) {
      fb.ilike('name', '%$q%');
    }
    final rows = await fb
        .order('reviews_count', ascending: false)
        .order('avg_rating', ascending: false);

    _items = (rows as List).cast<Map<String, dynamic>>().map((m) {
      final imgs = (m['images'] as List?)?.cast() ?? const [];
      return {
        'id': m['id'],
        'name': m['name'],
        'price': (m['price'] as num).toDouble(),
        'image': imgs.isNotEmpty ? imgs.first.toString() : null,
        'desc': (m['usage'] ?? '') as String,
        'slug': m['slug'],
        'avg_rating': ((m['avg_rating'] ?? 0) as num).toDouble(),
        'reviews_count': (m['reviews_count'] ?? 0) as int,
      };
    }).toList();

    if (mounted) setState(() => _loading = false);
  }

  int _cols(double w) {
    if (w >= 1400) return 5;
    if (w >= 1100) return 4;
    if (w >= 800) return 3;
    if (w >= 560) return 2;
    return 1;
  }

  void _openDrawer() => Scaffold.of(context).openEndDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: const [
              ListTile(
                leading: Icon(Icons.cached),
                title: Text('سياسة الاستبدال والاسترجاع'),
              ),
              ListTile(
                leading: Icon(Icons.local_shipping_outlined),
                title: Text('سياسة الشحن'),
              ),
              ListTile(
                leading: Icon(Icons.support_agent),
                title: Text('التواصل مع الدعم'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('لمسة حرير'),
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _openDrawer,
            tooltip: 'القائمة',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _search,
              onSubmitted: _fetch,
              decoration: InputDecoration(
                hintText: 'ابحث عن المنتج…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _search.clear();
                    _fetch('');
                  },
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, c) {
                final cols = _cols(c.maxWidth);
                return FadeTransition(
                  opacity: _fade,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final p = _items[i];
                      return ProductCard(
                        name: p['name'] as String,
                        price: p['price'] as double, // مرر double
                        image:
                            (p['image'] as String?) ??
                            'https://via.placeholder.com/600x800?text=Product',
                        rating: p['avg_rating'] as double,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: p,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: AppFooter(
        about: 'منتجات احترافية لعناية الشعر وفرده بدون فورمالين.',
        policies: 'استبدال/استرجاع خلال 14 يوم. شحن خلال 1-3 أيام عمل.',
        facebookUrl: 'https://facebook.com/yourpage',
        instagramUrl: 'https://instagram.com/yourpage',
        whatsappUrl: 'https://wa.me/201234567890',
        onWhatsapp: () {},
        onFacebook: () {},
        onInstagram: () {},
      ),
    );
  }
}
