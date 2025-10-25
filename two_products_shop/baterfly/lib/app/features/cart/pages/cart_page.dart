// lib/app/features/cart/pages/cart_page.dart
import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../core/widgets/footer_links/footer_links.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../domain/entities/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    cart.ensureLoaded();
    cart.addListener(_onChange);
  }

  @override
  void dispose() {
    cart.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final items = cart.items;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1A2A),
      appBar: const SiteAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: items.isEmpty
              ? const Center(
                  child: Text(
                    'السلة فارغة',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'سلة المشتريات',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (_, i) => _CartTile(item: items[i]),
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemCount: items.length,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF162133),
          border: Border(top: BorderSide(color: Color(0x22FFFFFF))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'الإجمالي: ${cart.subtotal.toStringAsFixed(0)} ج.م',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: items.isEmpty
                  ? null
                  : () => Navigator.pushNamed(context, '/checkout'),
              child: const Text(
                'إتمام الشراء',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: const FooterLinks(),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF162133),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x11FFFFFF)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.image.split(',').first.trim(),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 80,
                height: 80,
                child: ColoredBox(color: Color(0x11000000)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ج.م ${item.price.toStringAsFixed(0)}',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 10),
                _QtyControl(item: item),
              ],
            ),
          ),
          IconButton(
            tooltip: 'حذف',
            onPressed: () => cart.remove(item.id),
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final CartItem item;
  const _QtyControl({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => cart.decrement(item.id),
            icon: const Icon(Icons.remove, color: Colors.white70, size: 18),
          ),
          Text(
            '${item.qty}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          IconButton(
            onPressed: () => cart.increment(item.id),
            icon: const Icon(Icons.add, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }
}
