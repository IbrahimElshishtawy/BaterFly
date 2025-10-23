import 'dart:io';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  static String get platform {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    return 'Unknown';
  }
}
