import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase/supabase_service.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final SupabaseClient _sb = Supa.client;
  final String _table = 'products';

  @override
  Future<List<Product>> getProducts({int limit = 20}) async {
    final res = await _sb
        .from(_table)
        .select()
        .eq('active', true)
        .order('reviews_count', ascending: false)
        .order('avg_rating', ascending: false)
        .limit(limit);

    // ProductModel extends Product ⇒ نرجّعها مباشرة كـ Product
    return (res as List)
        .map((e) => ProductModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // لو واجهت توقيع مختلف في الـ interface عدّل الاسم هنا والـ interface سوا
  @override
  Future<Product?> getProductById(int id) async {
    final res = await _sb.from(_table).select().eq('id', id).maybeSingle();

    if (res == null) return null;
    return ProductModel.fromMap(res as Map<String, dynamic>);
  }
}
