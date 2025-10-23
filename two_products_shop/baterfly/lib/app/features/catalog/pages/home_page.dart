import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';
import '../widgets/product_card.dart';
import '../../product/pages/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final SupabaseClient _sb;
  late final AnimationController _ac;
  late final Animation<double> _fade;

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await _sb
        .from('products')
        .select()
        .eq('active', true)
        .order('reviews_count', ascending: false)
        .order('avg_rating', ascending: false)
        .limit(24);
    return (rows as List).map((e) => e as Map<String, dynamic>).map((m) {
      final imgs = (m['images'] as List?)?.cast() ?? const [];
      return {
        'id': m['id'],
        'name': m['name'],
        'price': (m['price'] as num).toDouble(),
        'image': imgs.isNotEmpty ? imgs.first.toString() : null,
        'desc': (m['usage'] ?? '') as String,
        'slug': m['slug'],
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _sb = Supa.client;
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  int _colsForWidth(double w) {
    if (w >= 1400) return 5;
    if (w >= 1100) return 4;
    if (w >= 800) return 3;
    if (w >= 560) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('متجر لمسة حرير'), centerTitle: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _load(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('حدث خطأ: ${snap.error}'));
          }
          final products = snap.data ?? const [];
          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات حالياً'));
          }

          return LayoutBuilder(
            builder: (context, c) {
              final cols = _colsForWidth(c.maxWidth);
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
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    final p = products[i];
                    return ProductCard(
                      name: p['name'] as String,
                      price: (p['price'] as double).toStringAsFixed(0),
                      image: (p['image']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductPage(product: p),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
