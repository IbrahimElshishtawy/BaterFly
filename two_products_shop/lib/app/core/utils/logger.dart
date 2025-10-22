import 'dart:developer' as dev;

class Log {
  static void i(String msg, [Object? data]) =>
      dev.log('[INFO] $msg ${data ?? ''}');
  static void e(String msg, [Object? err, StackTrace? st]) =>
      dev.log('[ERROR] $msg $err', stackTrace: st);
  static void d(String msg, [Object? data]) =>
      dev.log('[DEBUG] $msg ${data ?? ''}');
}
