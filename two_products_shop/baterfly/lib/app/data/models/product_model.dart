import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.price, // non-null
    required super.images,
    super.usage,
    required super.features,
    required super.active,
    required super.avgRating,
    required super.reviewsCount,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: _toInt(map['id'], fallback: 0),
      name: (map['name'] ?? '').toString(),
      slug: (map['slug'] ?? '').toString(),
      price: _toDouble(map['price'], fallback: 0.0),
      images: _toStringList(map['images']),
      usage: _toNullableString(map['usage']),
      features: _toStringList(map['features']),
      active: _toBool(map['active'], fallback: true),
      avgRating: _toDouble(map['avg_rating'], fallback: 0.0),
      reviewsCount: _toInt(map['reviews_count'], fallback: 0),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'slug': slug,
    'price': price,
    'images': images,
    'usage': usage,
    'features': features,
    'active': active,
    'avg_rating': avgRating,
    'reviews_count': reviewsCount,
  };

  // ---------- helpers آمنة ----------
  static double _toDouble(dynamic v, {double fallback = 0.0}) {
    if (v == null) return fallback;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? fallback;
  }

  static int _toInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }

  static bool _toBool(dynamic v, {bool fallback = false}) {
    if (v == null) return fallback;
    if (v is bool) return v;
    final s = v.toString().toLowerCase();
    if (s == 'true' || s == '1') return true;
    if (s == 'false' || s == '0') return false;
    return fallback;
  }

  static String? _toNullableString(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static List<String> _toStringList(dynamic v) {
    if (v == null) return const [];
    if (v is List) {
      return v
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    // لو رجع نص JSON/CSV
    final s = v.toString().trim();
    if (s.isEmpty) return const [];
    if (s.startsWith('[')) {
      try {
        // تجنب الاعتماد على dart:convert هنا لو مش مضاف، يمكن تفكيك بسيط:
        // الأفضل: import 'dart:convert'; ثم:
        // final l = jsonDecode(s) as List; return l.map((e)=>e.toString()).toList();
      } catch (_) {}
    }
    // CSV بدائي
    return s
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
