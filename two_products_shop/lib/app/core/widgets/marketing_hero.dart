import 'package:flutter/material.dart';
import '../../data/datasources/remote/products_remote.dart';
import '../../data/models/product_model.dart';
import 'animations/fade_slide.dart';

class MarketingHero extends StatefulWidget {
  final String? featuredProductId; // اختياري: هيرو لمنتج مميز
  const MarketingHero({super.key, this.featuredProductId});

  @override
  State<MarketingHero> createState() => _MarketingHeroState();
}

class _MarketingHeroState extends State<MarketingHero> {
  final _remote = ProductsRemote();
  ProductModel? _p;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.featuredProductId != null) {
      _fetch();
    }
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _p = await _remote.getById(widget.featuredProductId!);
      if (_p == null) _error = 'المنتج غير متاح';
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _p;

    return FadeSlide(
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
        child: _loading
            ? const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              )
            : _error != null || p == null
            ? _StaticHero() // بانر تسويقي ثابت لو مافيش منتج
            : _ProductHero(p: p),
      ),
    );
  }
}

class _StaticHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
                icon: const Icon(Icons.local_fire_department_outlined),
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
    );
  }
}

class _ProductHero extends StatelessWidget {
  final ProductModel p;
  const _ProductHero({required this.p});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // نص تسويقي
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.title, style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 8),
              if ((p.description ?? '').isNotEmpty)
                Text(
                  p.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: p.inStock ? () {} : null,
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: Text(p.inStock ? 'أضف إلى السلة' : 'غير متوفر'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility_outlined),
                    label: Text('${p.displayPrice} EGP'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // صورة المنتج
        Flexible(
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: p.imageUrl != null
                  ? Image.network(p.imageUrl!, fit: BoxFit.cover)
                  : Container(color: const Color(0xFFE9EEF5)),
            ),
          ),
        ),
      ],
    );
  }
}
