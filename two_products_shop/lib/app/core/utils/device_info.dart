// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

class DeviceInfo {
  static String get userAgent => html.window.navigator.userAgent;
  static String get language => html.window.navigator.language ?? 'ar';
}
