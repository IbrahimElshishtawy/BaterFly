import 'package:flutter/material.dart';

class Txt {
  static TextStyle get h1 =>
      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static TextStyle get h2 =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle get body => const TextStyle(fontSize: 14, height: 1.5);
  static TextStyle get small =>
      const TextStyle(fontSize: 12, color: Colors.grey);
}
