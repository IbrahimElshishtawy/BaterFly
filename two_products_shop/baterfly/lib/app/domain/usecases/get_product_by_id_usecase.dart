import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUsecase {
  final ProductRepository repo;
  GetProductByIdUsecase(this.repo);

  Future<Product?> call(int id) => repo.getProductById(id);
}
