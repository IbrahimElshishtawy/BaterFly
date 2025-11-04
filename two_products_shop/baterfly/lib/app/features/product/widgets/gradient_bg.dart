// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🩶 خلفية رئيسية بسيطة وناعمة
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0C14),
                Color(0xFF101828),
                Color(0xFF18283B),
                Color(0xFF1E3350),
              ],
            ),
          ),
        ),

        /// 🌫️ إضاءات ناعمة غير دائرية (Soft Glow Shapes)
        _softGlowShape(
          const Color(0xFF007BFF).withOpacity(0.2),
          width: 280,
          height: 160,
          top: 80,
          left: -60,
        ),
        _softGlowShape(
          const Color(0xFFFF6A00).withOpacity(0.22),
          width: 320,
          height: 180,
          bottom: 60,
          right: -50,
        ),
        _softGlowShape(
          const Color(0xFF00FFC6).withOpacity(0.15),
          width: 200,
          height: 140,
          top: 300,
          right: 60,
        ),

        /// 🌠 حركة خلفية خفيفة (إضاءة بطيئة بتتحرك)
        Positioned.fill(
          child:
              Container(
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        center: Alignment.center,
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.1, 0.6, 0.9],
                      ),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .rotate(duration: 25.seconds)
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.05, 1.05),
                    duration: 12.seconds,
                  ),
        ),

        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.1))),

        Positioned.fill(
          child:
              Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 2,
                        colors: [
                          Colors.white.withOpacity(0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fadeIn(duration: 4.seconds)
                  .shimmer(duration: 10.seconds),
        ),
      ],
    );
  }

  /// 🌀 شكل إضاءة ناعمة (مش دايرة، شبه بيضاوي أو "Cloud Light")
  static Widget _softGlowShape(
    Color color, {
    double? top,
    double? bottom,
    double? left,
    double? right,
    double width = 200,
    double height = 120,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: 0.4,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: RadialGradient(
              colors: [color, Colors.transparent],
              radius: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: 120,
                spreadRadius: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
