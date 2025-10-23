import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class SupabaseClientHolder {
  static SupabaseClient get instance => Supa.client;
}
