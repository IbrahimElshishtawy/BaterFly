import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async =>
      dotenv.load(fileName: 'lib/app/assets/.env');
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
