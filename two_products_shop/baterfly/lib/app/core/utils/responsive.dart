import 'package:flutter/material.dart';

class Responsive {
  static EdgeInsets hpad(double w) {
    if (w >= 1440) return const EdgeInsets.symmetric(horizontal: 32);
    if (w >= 1024) return const EdgeInsets.symmetric(horizontal: 28);
    if (w >= 768) return const EdgeInsets.symmetric(horizontal: 24);
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  static double maxWidth(double w) {
    if (w >= 1440) return 1240;
    if (w >= 1280) return 1140;
    return 1100;
  }

  static double heroHeight(double w) {
    if (w >= 1600) return 540;
    if (w >= 1200) return 460;
    if (w >= 768) return 360;
    return 240;
  }

  static Widget wrap({
    required double maxW,
    required EdgeInsets pad,
    required Widget child,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(padding: pad, child: child),
      ),
    );
  }
}
