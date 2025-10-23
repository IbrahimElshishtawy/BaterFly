import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase/supabase_service.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final SupabaseClient _sb = Supa.client;
  final String _table = 'products';

  @override
  Future<List<Product>> getPopularProducts({int limit = 20}) async {
    final res = await _sb
        .from(_table)
        .select()
        .eq('active', true)
        .order('reviews_count', ascending: false)
        .order('avg_rating', ascending: false)
        .limit(limit);

    return (res as List)
        .map((e) => ProductModel.fromMap(e).toEntity())
        .toList();
  }

  @override
  Future<Product?> getById(String idOrSlug) async {
    final q = _sb.from(_table).select().limit(1);
    final id = int.tryParse(idOrSlug);
    if (id != null) {
      q.eq('id', id);
    } else {
      q.eq('slug', idOrSlug);
    }
    final res = await q.maybeSingle();
    if (res == null) return null;
    return ProductModel.fromMap(res as Map<String, dynamic>).toEntity();
  }
}
