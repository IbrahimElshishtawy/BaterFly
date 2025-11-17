// lib/app/services/supabase/product_service.dart
// ignore_for_file: file_names

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:baterfly/app/data/models/product_model.dart';

class ProductService {
  final _client = Supabase.instance.client;

  Future<ProductModel?> getProductBySlug(String slug) async {
    final response = await _client
        .from('products')
        .select()
        .eq('slug', slug)
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) return null;
    return ProductModel.fromJson(response);
  }

  Future<List<ProductModel>> getActiveProducts() async {
    final response = await _client
        .from('products')
        .select()
        .eq('is_active', true);

    final list = (response as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return list;
  }
}
