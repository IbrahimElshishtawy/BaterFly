// lib/app/features/checkout/services/checkout_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutService {
  final supabase = Supabase.instance.client;

  Future<String> sendOrder({required Map<String, dynamic> orderData}) async {
    orderData.remove("id");
    orderData.remove("order_no");

    final response = await supabase
        .from("orders")
        .insert(orderData)
        .select("order_no")
        .single();

    return response["order_no"].toString();
  }
}
