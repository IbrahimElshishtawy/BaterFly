// lib/app/features/cart/cart_service.dart
import '../../domain/entities/product.dart';

extension ProductSalePrice on Product {
  // Provide a nullable salePrice getter so code that expects salePrice can compile.
  // Returning null will make callers fall back to price, matching previous usage.
  double? get salePrice => null;
}

class CartItem {
  final Product p;
  final int qty;
  final double? discountPct;
  CartItem({required this.p, this.qty = 1, this.discountPct});
}

class CartService {
  static final CartService I = CartService._();
  CartService._();

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  void add(Product p, {int qty = 1, double? discountPct}) {
    final q = qty <= 0 ? 1 : qty;
    _items.add(CartItem(p: p, qty: q, discountPct: discountPct));
  }

  double lineTotal(CartItem i) {
    final unit = (i.p.salePrice ?? i.p.price);
    final d = (i.discountPct ?? 0) / 100.0;
    final q = i.qty <= 0 ? 1 : i.qty;
    return unit * (1 - d) * q;
  }

  double total() => _items.fold(0.0, (s, it) => s + lineTotal(it));
}
