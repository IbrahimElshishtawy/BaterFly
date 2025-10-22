import 'package:supabase_flutter/supabase_flutter.dart';

class Supa {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> init({String? url, String? anonKey}) async {
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://nqjojfeknzmyqtqpvwqb.supabase.co',
    );
    const supabaseAnon = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xam9qZmVrbnpteXF0cXB2d3FiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEwNjcyNTksImV4cCI6MjA3NjY0MzI1OX0.3DqoR9vkJqOZnNdiwEE55fAnulZpNjXQFBRbRtgznJg',
    );

    await Supabase.initialize(
      url: url ?? supabaseUrl,
      anonKey: anonKey ?? supabaseAnon,
      debug: false,
    );
  }
}
