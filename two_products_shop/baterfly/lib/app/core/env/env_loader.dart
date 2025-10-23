import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async => await dotenv.load();

  static String get url =>
      dotenv.env['https://nqjojfeknzmyqtqpvwqb.supabase.co'] ?? '';
  static String get anonKey =>
      dotenv
          .env['eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xam9qZmVrbnpteXF0cXB2d3FiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEwNjcyNTksImV4cCI6MjA3NjY0MzI1OX0.3DqoR9vkJqOZnNdiwEE55fAnulZpNjXQFBRbRtgznJg'] ??
      '';
}
