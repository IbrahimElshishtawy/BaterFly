import 'package:baterfly/app/domain/entities/cart_item.dart';
import '../../data/datasources/local/cart_storage.dart';

class CartRepository {
  final CartStorage storage;
  CartRepository(this.storage);

  Future<List<CartItem>> load() async =>
      (await storage.read()).map(CartItem.fromJson).toList();

  Future<void> save(List<CartItem> items) =>
      storage.write(items.map((e) => e.toJson()).toList());

  Future<void> clear() => storage.clear();
}
