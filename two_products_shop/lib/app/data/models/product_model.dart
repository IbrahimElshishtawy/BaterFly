import 'dart:convert' as json;

class ProductModel {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final List<String> images;
  final num price;
  final num? salePrice;
  final bool inStock;
  final String? usage;
  final List<String> features;
  final String? slug;

  const ProductModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.images = const [],
    required this.price,
    this.salePrice,
    required this.inStock,
    this.usage,
    this.features = const [],
    this.slug,
  });

  num get displayPrice => salePrice ?? price;

  factory ProductModel.fromMap(Map<String, dynamic> m) {
    // images قد تأتي كنص JSON أو List
    final rawImages = m['images'];
    final List<String> imgs = switch (rawImages) {
      List l => l.map((e) => '$e').toList(),
      String s when s.trim().startsWith('[') => List<String>.from(
        (json.jsonDecode(s) as List).map((e) => '$e'),
      ),
      _ => const <String>[],
    };

    final imgUrl =
        (m['image_url'] as String?) ?? (imgs.isNotEmpty ? imgs.first : null);

    final featsRaw = m['features'];
    final List<String> feats = switch (featsRaw) {
      List l => l.map((e) => '$e').toList(),
      String s when s.trim().startsWith('[') => List<String>.from(
        (json.jsonDecode(s) as List).map((e) => '$e'),
      ),
      _ => const <String>[],
    };

    return ProductModel(
      id: '${m['id']}',
      title: (m['title'] ?? m['name'] ?? '').toString(),
      description: (m['description'] ?? m['usage']) as String?,
      imageUrl: imgUrl,
      images: imgs,
      price: (m['price'] ?? 0) as num,
      salePrice: m['sale_price'] as num?,
      inStock: (m['in_stock'] ?? m['active'] ?? true) as bool,
      usage: m['usage'] as String?,
      features: feats,
      slug: m['slug'] as String?,
    );
  }
}
