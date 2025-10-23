import 'package:flutter/material.dart';

class FadeSlide extends StatelessWidget {
  final Widget child;
  final double offset;
  final Duration duration;
  const FadeSlide({
    super.key,
    required this.child,
    this.offset = 30,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offset * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}
