import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product_model.dart';

class ProductsRemote {
  final SupabaseClient _sb = Supabase.instance.client;
  final String _table = 'products';

  Future<List<ProductModel>> listPopular({int limit = 20}) async {
    final res = await _sb
        .from(_table)
        .select()
        .eq('active', true)
        .order('popularity', ascending: false)
        .limit(limit);
    return (res as List)
        .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel?> getById(String id) async {
    final res = await _sb.from(_table).select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return ProductModel.fromMap(res);
  }

  Future<List<ProductModel>> fetchActive({int limit = 50}) async {
    final res = await _sb.from(_table).select().eq('active', true).limit(limit);
    return (res as List)
        .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel?> fetchBySlug(String slug) async {
    final res = await _sb.from(_table).select().eq('slug', slug).maybeSingle();
    if (res == null) return null;
    return ProductModel.fromMap(res);
  }

  Future<List<ProductModel>> search(String query, {int limit = 30}) async {
    final res = await _sb
        .from(_table)
        .select()
        .ilike('title', '%$query%')
        .limit(limit);
    return (res as List)
        .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
