import 'package:flutter/material.dart';
import 'package:two_products_shop/app/data/datasources/remote/products_remote.dart';
import 'package:two_products_shop/app/data/models/product_model.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  const ProductPage({super.key, required this.productId});
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  final _remote = ProductsRemote();
  ProductModel? product;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      product = await _remote.getById(widget.productId);
      if (product == null) error = 'المنتج غير متاح';
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null)
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error!)),
      );
    final p = product!;

    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'p-img-${p.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 1.4,
                child: p.imageUrl != null
                    ? Image.network(p.imageUrl!, fit: BoxFit.cover)
                    : Container(color: const Color(0xFFE9EEF5)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          FadeSlide(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    p.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${p.displayPrice} EGP',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          if ((p.description ?? '').isNotEmpty)
            FadeSlide(
              delay: const Duration(milliseconds: 80),
              child: Text(
                p.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

          const SizedBox(height: 18),

          FadeSlide(
            delay: const Duration(milliseconds: 140),
            child: FilledButton.icon(
              onPressed: p.inStock ? () {} : null,
              icon: const Icon(Icons.add_shopping_cart_rounded),
              label: Text(p.inStock ? 'أضف إلى السلة' : 'غير متوفر'),
            ),
          ),

          const SizedBox(height: 22),

          // مقطع فوائد/مميزات تسويقية
          FadeSlide(
            delay: const Duration(milliseconds: 200),
            child: _Benefits(),
          ),
        ],
      ),
    );
  }
}

class _Benefits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.verified, 'جودة مضمونة'),
      (Icons.local_shipping_outlined, 'توصيل سريع'),
      (Icons.lock_outline, 'دفع آمن'),
      (Icons.reviews_outlined, 'تقييمات موثوقة'),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1418273A),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 12,
        children: items
            .map(
              (e) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e.$1, size: 18),
                  const SizedBox(width: 6),
                  Text(e.$2),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
