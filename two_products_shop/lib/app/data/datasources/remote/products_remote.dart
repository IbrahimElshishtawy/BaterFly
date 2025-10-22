// ignore_for_file: unnecessary_cast

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_client.dart';
import '../../../core/config/app_constants.dart';
import '../../models/product_model.dart';

class ProductsRemote {
  final SupabaseClient _db = Supa.client;

  Future<List<ProductModel>> fetchActive() async {
    final res = await _db
        .from(AppConstants.tblProducts)
        .select()
        .eq(AppConstants.fActive, true)
        .order(AppConstants.fId);
    return (res as List)
        .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel?> fetchBySlug(String slug) async {
    final res = await _db
        .from(AppConstants.tblProducts)
        .select()
        .eq(AppConstants.fSlug, slug)
        .maybeSingle();
    if (res == null) return null;
    return ProductModel.fromMap(res as Map<String, dynamic>);
  }
}
