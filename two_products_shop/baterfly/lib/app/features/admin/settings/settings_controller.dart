import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class AdminSettingsController {
  static const _table = 'settings';
  final SupabaseClient _sb = Supa.client;

  Future<Map<String, dynamic>?> fetch() async {
    final row = await _sb.from(_table).select().eq('id', 1).maybeSingle();
    return row == null ? null : Map<String, dynamic>.from(row);
  }

  Future<void> save({
    String? whatsappNumber,
    String? supportEmail,
    Map<String, dynamic>? shippingMatrix,
  }) async {
    final data = <String, dynamic>{};
    if (whatsappNumber != null) data['whatsapp_number'] = whatsappNumber;
    if (supportEmail != null) data['support_email'] = supportEmail;
    if (shippingMatrix != null) data['shipping_matrix'] = shippingMatrix;
    if (data.isEmpty) return;
    await _sb.from(_table).update(data).eq('id', 1);
  }
}
