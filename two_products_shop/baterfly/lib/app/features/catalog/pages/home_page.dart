import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/widgets/footer_links.dart';
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
  final _q = ValueNotifier<String>('');
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  )..forward();

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await _sb
        .from('products')
        .select('id,name,slug,price,images,avg_rating')
        .eq('active', true)
        .order('reviews_count', ascending: false)
        .order('avg_rating', ascending: false)
        .limit(60);
    final list = (rows as List).cast<Map<String, dynamic>>();
    final q = _q.value.trim();
    if (q.isEmpty) return list;
    return list
        .where(
          (m) =>
              (m['name'] ?? '').toString().contains(q) ||
              (m['slug'] ?? '').toString().contains(q),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _sb = Supa.client;
  }

  int _cols(double w) {
    if (w >= 1400) return 5;
    if (w >= 1100) return 4;
    if (w >= 800) return 3;
    if (w >= 560) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const ListTile(
                title: Center(
                  child: Text(
                    'الأقسام',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('سياسة الاستبدال والاسترجاع'),
                onTap: () {},
              ),
              ListTile(title: const Text('سياسة الشحن'), onTap: () {}),
              ListTile(title: const Text('التواصل مع الدعم'), onTap: () {}),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('لمسة حرير'),
        leadingWidth: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final res = await showSearch<String?>(
                context: context,
                delegate: _SearchDelegate(initial: _q.value),
              );
              if (res != null) setState(() => _q.value = res);
            },
          ),
          Builder(
            builder: (c) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(c).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _load(),
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = s.data ?? const [];
          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (_, c) {
                    final cols = _cols(c.maxWidth);
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: .78,
                      ),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final m = items[i];
                        final imgs = (m['images'] as List?)?.cast() ?? const [];
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _ac,
                            curve: Interval(0, 1, curve: Curves.easeOut),
                          ),
                          child: ProductCard(
                            name: m['name'],
                            price: (m['price'] as num).toDouble(),
                            rating: ((m['avg_rating'] ?? 0) as num).toDouble(),
                            image: imgs.isNotEmpty
                                ? imgs.first.toString()
                                : 'https://via.placeholder.com/800x1000?text=Product',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product',
                                arguments: {
                                  ...m,
                                  'image': imgs.isNotEmpty
                                      ? imgs.first.toString()
                                      : null,
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const FooterLinks(),
            ],
          );
        },
      ),
    );
  }
}

class _SearchDelegate extends SearchDelegate<String?> {
  _SearchDelegate({String initial = ''}) {
    query = initial;
  }
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );
  @override
  Widget buildResults(BuildContext context) => _hint();
  @override
  Widget buildSuggestions(BuildContext context) => _hint();
  Widget _hint() => Center(child: Text('اكتب اسم المنتج ثم Enter: $query'));
  @override
  void showResults(BuildContext context) {
    close(context, query);
  }
}
