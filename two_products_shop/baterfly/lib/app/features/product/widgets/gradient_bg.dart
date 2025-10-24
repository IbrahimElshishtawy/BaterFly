import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B1020), Color(0xFF0E1A2A)],
            ),
          ),
        ),
        _bubble(const Color(0x3322D1FF), 220, right: -60, top: 120),
        _bubble(const Color(0x334BFF7A), 180, left: -40, top: 320),
        _bubble(const Color(0x33FF7AC6), 160, right: -30, bottom: 120),
      ],
    );
  }

  static Widget _bubble(
    Color c,
    double s, {
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c,
          boxShadow: [BoxShadow(color: c, blurRadius: 60, spreadRadius: 20)],
        ),
      ),
    );
  }
}
