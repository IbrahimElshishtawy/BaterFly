import 'package:supabase_flutter/supabase_flutter.dart';

class Supa {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> init({String? url, String? anonKey}) async {
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://YOUR-PROJECT.supabase.co',
    );
    const supabaseAnon = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'YOUR-ANON-KEY',
    );

    await Supabase.initialize(
      url: url ?? supabaseUrl,
      anonKey: anonKey ?? supabaseAnon,
      debug: false,
    );
  }
}
