import 'package:flutter/material.dart';

class AppError {
  static void handleFlutter(FlutterErrorDetails d) {
    FlutterError.dumpErrorToConsole(d);
  }

  static void showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  static Never throwState(String message) => throw StateError(message);
}
