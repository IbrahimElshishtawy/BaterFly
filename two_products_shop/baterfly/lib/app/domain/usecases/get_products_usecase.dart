import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUsecase {
  final ProductRepository repo;
  GetProductsUsecase(this.repo);

  Future<List<Product>> call({int limit = 20}) =>
      repo.getProducts(limit: limit);
}
