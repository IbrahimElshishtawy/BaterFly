import '../../../data/datasources/remote/products_remote.dart';
import '../../../data/models/product_model.dart';

class ProductController {
  final ProductsRemote _remote;
  ProductController({ProductsRemote? remote})
    : _remote = remote ?? ProductsRemote();

  Future<List<ProductModel>> listPopular({int limit = 12}) =>
      _remote.listPopular(limit: limit);
}
