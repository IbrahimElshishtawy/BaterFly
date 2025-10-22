import 'dart:io';

class NetworkChecker {
  static Future<bool> get isOnline async {
    try {
      final res = await InternetAddress.lookup('example.com');
      return res.isNotEmpty && res[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
