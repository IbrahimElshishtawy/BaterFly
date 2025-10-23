import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int limit});
  Future<Product?> getProductById(int id);
}
