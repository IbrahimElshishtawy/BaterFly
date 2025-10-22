// ignore_for_file: deprecated_member_use

import 'dart:math';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class Session {
  static const _k = 'app_session_id';

  static String ensure() {
    final ls = html.window.localStorage;
    final existing = ls[_k];
    if (existing != null && existing.isNotEmpty) return existing;

    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    final id = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    ls[_k] = id;
    return id;
  }
}
