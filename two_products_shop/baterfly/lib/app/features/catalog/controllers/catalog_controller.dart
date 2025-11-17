import '../../../data/datasources/remote/products_remote.dart';

class CatalogController {
  final ProductsRemote _remote;
  CatalogController({ProductsRemote? remote})
    : _remote = remote ?? ProductsRemote();

  Future<List<Map<String, dynamic>>> listAsMap({int limit = 12}) async {
    final models = await _remote.listPopular(limit: limit);
    return models
        .map(
          (e) => {
            'id': e.id,
            'name': e.name,

            'image': (e.images.isNotEmpty ? e.images.first : null),
            'desc': e.usage,

            'usage': e.usage,
          },
        )
        .toList();
  }
}
