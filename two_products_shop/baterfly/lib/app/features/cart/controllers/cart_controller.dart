import 'package:baterfly/app/data/datasources/local/cart_storage.dart';
import 'package:flutter/foundation.dart';
import '../../../data/repositories/cart_repository_impl.dart';
import '../../../domain/entities/cart_item.dart';

class CartController extends ChangeNotifier {
  final CartRepository repo;
  CartController(this.repo);

  final List<CartItem> _items = [];
  bool _loaded = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get totalQty => _items.fold(0, (s, e) => s + e.qty);
  double get subtotal => _items.fold(0.0, (s, e) => s + e.lineTotal);

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final list = await repo.load();
    _items
      ..clear()
      ..addAll(list);
    _loaded = true;
    notifyListeners();
  }

  Future<void> add(CartItem item, {int qty = 1}) async {
    await ensureLoaded();
    final i = _items.indexWhere((e) => e.id == item.id);
    if (i == -1) {
      _items.add(item.copyWith(qty: qty));
    } else {
      _items[i] = _items[i].copyWith(qty: _items[i].qty + qty);
    }
    await repo.save(_items);
    notifyListeners();
  }

  Future<void> increment(String id) async {
    await ensureLoaded();
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return;
    _items[i] = _items[i].copyWith(qty: _items[i].qty + 1);
    await repo.save(_items);
    notifyListeners();
  }

  Future<void> decrement(String id) async {
    await ensureLoaded();
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final q = _items[i].qty - 1;
    if (q <= 0) {
      _items.removeAt(i);
    } else {
      _items[i] = _items[i].copyWith(qty: q);
    }
    await repo.save(_items);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await ensureLoaded();
    _items.removeWhere((e) => e.id == id);
    await repo.save(_items);
    notifyListeners();
  }

  Future<void> clear() async {
    _items.clear();
    await repo.clear();
    notifyListeners();
  }
}

final CartController cart = CartController(CartRepository(CartStorage()));
