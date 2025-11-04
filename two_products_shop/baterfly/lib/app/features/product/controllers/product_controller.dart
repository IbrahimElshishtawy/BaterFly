// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
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
          .maybeSingle(); // ✅ أكثر أماناً من .single()

      if (response == null) {
        throw Exception('Product not found');
      }

      product.value = response;
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          titleText: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          messageText: Text(
            'Failed to load product: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFd32f2f), // لون أحمر غامق
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
