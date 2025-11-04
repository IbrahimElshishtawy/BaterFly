import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var product = {}.obs;

  Future<void> fetchProduct(int productId) async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('products')
          .select()
          .eq('id', productId)
          .single();

      product.value = response;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
