import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product_model.dart';
import '../../../services/supabase/supabase_service.dart';

class ProductsRemote {
  final SupabaseClient _sb = Supa.client;
  final String _table = 'products';

  Future<List<ProductModel>> listPopular({int limit = 20}) async {
    final res = await _sb
        .from(_table)
        .select()
        .eq('active', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return (res as List)
        .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel?> getById(int id) async {
    final res = await _sb.from(_table).select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return ProductModel.fromMap(res);
  }
}
