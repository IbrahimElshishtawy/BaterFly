class ProductModel {
  final String id; // ex: UUID أو رقم كنص
  final String title; // الاسم المعروض
  final String? description;
  final String? imageUrl;
  final List<String> images; // صور متعددة
  final num price;
  final num? salePrice;
  final bool inStock;
  final String? usage; // نص إرشادات الاستخدام
  final List<String> features; // نقاط مميزات

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
  });

  num get displayPrice => salePrice ?? price;

  // توافق مع أعمدة شائعة: name/title, image_url/images, features كـ json/text[]
  factory ProductModel.fromMap(Map<String, dynamic> m) => ProductModel(
    id: '${m['id']}',
    title: (m['title'] ?? m['name'] ?? '').toString(),
    description: m['description'] as String?,
    imageUrl: m['image_url'] as String?,
    images: (m['images'] as List?)?.map((e) => '$e').toList() ?? const [],
    price: (m['price'] ?? 0) as num,
    salePrice: m['sale_price'] as num?,
    inStock: (m['in_stock'] ?? true) as bool,
    usage: m['usage'] as String?,
    features: (m['features'] as List?)?.map((e) => '$e').toList() ?? const [],
  );
}
