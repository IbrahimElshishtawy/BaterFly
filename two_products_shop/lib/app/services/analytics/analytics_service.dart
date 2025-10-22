class AnalyticsService {
  static void log(String event, [Map<String, dynamic>? params]) {
    // ignore: avoid_print
    print('[ANALYTICS] $event ${params ?? {}}');
  }
}
