import 'package:flutter/material.dart';

/// خدمة مسؤولة عن إرسال إشعارات داخل الموقع.
/// في Flutter Web لن تعمل إشعارات النظام مباشرة، لكن يمكن استخدام SnackBars أو Dialogs.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  void showSnackBar(
    BuildContext context,
    String message, {
    Color background = Colors.teal,
    int seconds = 3,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
        backgroundColor: background,
      ),
    );
  }

  void showError(BuildContext context, String message) {
    showSnackBar(context, message, background: Colors.red);
  }

  void showSuccess(BuildContext context, String message) {
    showSnackBar(context, message, background: Colors.green);
  }
}
