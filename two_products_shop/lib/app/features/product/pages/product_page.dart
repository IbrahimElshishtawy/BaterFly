import 'package:flutter/material.dart';
import '../../../data/datasources/remote/products_remote.dart';
import '../../../data/models/product_model.dart';
import '../../../core/routing/app_router.dart';
import '../../reviews/widgets/review_section.dart';

class ProductPage extends StatefulWidget {
  final String slug;
  const ProductPage({super.key, required this.slug});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _remote = ProductsRemote();
  ProductModel? _product;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await _remote.fetchBySlug(widget.slug);
    if (mounted) {
      setState(() {
        _product = p;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final p = _product;
    if (p == null) {
      return const Scaffold(body: Center(child: Text('المنتج غير موجود')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (p.images.isNotEmpty)
              SizedBox(
                height: 260,
                child: PageView(
                  children: p.images
                      .map((img) => Image.network(img, fit: BoxFit.cover))
                      .toList(),
                ),
              ),
            const SizedBox(height: 12),
            Text(p.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '${p.price.toStringAsFixed(0)} ج.م',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(p.usage ?? '', style: const TextStyle(height: 1.5)),
            const SizedBox(height: 12),
            const Text(
              'الميزات:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...p.features.map((f) => Text('• $f')).toList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text('اطلب الآن'),
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRouter.checkout,
                  arguments: {'productId': p.id, 'qty': 1},
                ),
              ),
            ),
            const SizedBox(height: 24),
            ReviewSection(productId: p.id),
          ],
        ),
      ),
    );
  }
}
