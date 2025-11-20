// ignore_for_file: file_names

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:baterfly/app/data/models/product_model.dart';

class ProductService {
  final SupabaseClient _client = Supabase.instance.client;

  /// جلب كل المنتجات (مرة واحدة)
  Future<List<ProductModel>> getActiveProducts() async {
    final data = await _client
        .from('products')
        .select()
        .order('id', ascending: true);

    return (data as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Stream<List<ProductModel>> watchProducts() {
    return _client
        .from('products')
        .stream(primaryKey: ['id'])
        .order('id', ascending: true)
        .map((rows) => rows.map((e) => ProductModel.fromJson(e)).toList());
  }

  Future<ProductModel?> getProductBySlug(String slug) async {
    final data = await _client
        .from('products')
        .select()
        .eq('slug', slug)
        .maybeSingle();

    if (data == null) return null;
    return ProductModel.fromJson(data);
  }

  Future<void> updateProduct(ProductModel product) async {
    await _client
        .from('products')
        .update(product.toJson())
        .eq('id', product.id as Object);
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    final inserted = await _client
        .from('products')
        .insert(product.toJsonForInsert())
        .select()
        .single();

    return ProductModel.fromJson(inserted);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  Future<List<ProductModel>> searchProducts({
    required String query,
    String? categorySlug,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    var req = _client.from('products').select('*').eq('is_active', true);

    if (query.isNotEmpty) {
      req = req.or('name.ilike.%$query%,description.ilike.%$query%');
    }

    if (categorySlug != null && categorySlug.isNotEmpty) {
      req = req.eq('category_slug', categorySlug);
    }
    if (minPrice != null) {
      req = req.gte('price', minPrice);
    }
    if (maxPrice != null) {
      req = req.lte('price', maxPrice);
    }
    if (minRating != null) {
      req = req.gte('avg_rating', minRating);
    }

    final data = await req.order('created_at', ascending: false);

    return (data as List)
        .map((json) => ProductModel.fromMap(json as Map<String, dynamic>))
        .toList();
  }
}
