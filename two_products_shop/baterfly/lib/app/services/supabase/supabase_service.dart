import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Supa {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://nqjojfeknzmyqtqpvwqb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xam9qZmVrbnpteXF0cXB2d3FiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEwNjcyNTksImV4cCI6MjA3NjY0MzI1OX0.3DqoR9vkJqOZnNdiwEE55fAnulZpNjXQFBRbRtgznJg',
      authOptions: FlutterAuthClientOptions(autoRefreshToken: true),
    );

    if (kDebugMode) {
      print('✅ Supabase initialized successfully');
    }
  }
}
