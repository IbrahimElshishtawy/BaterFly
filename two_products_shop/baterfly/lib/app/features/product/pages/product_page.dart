// ignore_for_file: unnecessary_underscores

import 'package:baterfly/app/core/widgets/order_sheet.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String;
    final price = (product['price'] as num).toDouble();
    final desc = (product['desc'] ?? '') as String;
    final img =
        (product['image'] as String?) ??
        'https://via.placeholder.com/800x1000?text=Product';
    final features =
        (product['features'] as List?)?.cast<String>() ?? const <String>[];

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'p_${product['id']}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.network(img, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '${Fmt.price(price)} ج.م',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(desc.isEmpty ? 'وصف المنتج غير متوفر' : desc),
          if (features.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'مميزات الاستخدام',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...features.map(
              (e) => Row(
                children: [
                  const Icon(Icons.check, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          Center(
            child: _CtaButton(
              onPressed: () async {
                final orderNo = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.7,
                    minChildSize: 0.5,
                    maxChildSize: 0.95,
                    builder: (_, __) => OrderSheet(
                      productId: product['id'] as int,
                      productName: name,
                    ),
                  ),
                );
                if (orderNo != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم إنشاء الطلب: $orderNo')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _CtaButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _CtaButton({required this.onPressed});

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scale = Tween(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
    _ac.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FilledButton.icon(
        icon: const Icon(Icons.flash_on),
        label: const Text('اطلب الآن'),
        onPressed: widget.onPressed,
      ),
    );
  }
}
