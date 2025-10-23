import 'dart:developer';

class Logger {
  static void info(String message) => log('ℹ️ $message');
  static void error(String message) => log('❌ $message');
}
