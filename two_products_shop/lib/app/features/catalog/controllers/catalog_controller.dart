import 'package:flutter/foundation.dart';
import '../../../data/datasources/remote/products_remote.dart';
import '../../../data/models/product_model.dart';

class CatalogController with ChangeNotifier {
  final ProductsRemote _remote;
  CatalogController(this._remote);

  bool loading = false;
  List<ProductModel> items = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      items = await _remote.fetchActive();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
