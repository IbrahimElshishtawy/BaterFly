import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/env/env_loader.dart';

class Supa {
  static SupabaseClient get client => SupabaseClient(Env.url, Env.anonKey);

  static Future<void> init() async {
    await Supabase.initialize(url: Env.url, anonKey: Env.anonKey);
  }
}
