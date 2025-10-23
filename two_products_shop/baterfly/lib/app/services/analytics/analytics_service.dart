class AnalyticsService {
  static void log(String event, [Map<String, dynamic>? params]) {
    // ممكن تربطه بـ Google Analytics أو Firebase لاحقًا
    // placeholder event logger
    // ignore: avoid_print
    print('[Analytics] $event: $params');
  }
}
