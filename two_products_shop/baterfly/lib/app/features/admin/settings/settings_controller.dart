import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class AdminSettingsController {
  final SupabaseClient _sb = Supa.client;
  final String _table = 'settings';

  Future<Map<String, dynamic>> load() async {
    final res = await _sb.from(_table).select().eq('id', 1).maybeSingle();
    return res ?? <String, dynamic>{};
  }

  Future<void> save({
    String? whatsappNumber,
    String? supportEmail,
    Map<String, dynamic>? shippingMatrix,
  }) async {
    await _sb.from(_table).upsert({
      'id': 1,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (supportEmail != null) 'support_email': supportEmail,
      if (shippingMatrix != null) 'shipping_matrix': shippingMatrix,
    }, onConflict: 'id');
  }
}
