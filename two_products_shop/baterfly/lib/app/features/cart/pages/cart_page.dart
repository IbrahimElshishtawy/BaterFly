import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('السلة')),
      body: items.isEmpty
          ? const Center(child: Text('السلة فارغة'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, i) => _CartTile(item: items[i]),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length,
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: const Border(top: BorderSide(color: Color(0x11000000))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'الإجمالي: ${cart.subtotal.toStringAsFixed(0)} ج.م',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            FilledButton(
              onPressed: items.isEmpty
                  ? null
                  : () => Navigator.pushNamed(context, '/checkout'),
              child: const Text('إتمام الشراء'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x11000000)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image.split(',').first.trim(),
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 72,
                height: 72,
                child: ColoredBox(color: Color(0x11000000)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'ج.م ${item.price.toStringAsFixed(0)}',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'حذف',
            onPressed: () => cart.remove(item.id),
            icon: const Icon(Icons.delete_outline),
          ),
          const SizedBox(width: 4),
          _QtyControl(item: item),
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
    return Row(
      children: [
        IconButton(
          onPressed: () => cart.decrement(item.id),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          '${item.qty}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        IconButton(
          onPressed: () => cart.increment(item.id),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
