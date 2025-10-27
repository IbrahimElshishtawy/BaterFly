// lib/app/features/catalog/widgets/product_card/animated_image_slider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'image_any.dart';

class AnimatedImageSlider extends StatefulWidget {
  final List<String> images;
  final Duration interval;
  final double borderRadius;
  final bool autoPlay;
  final ValueChanged<int>? onIndexChanged;

  const AnimatedImageSlider({
    super.key,
    required this.images,
    this.interval = const Duration(seconds: 3),
    this.borderRadius = 12,
    this.autoPlay = true,
    this.onIndexChanged,
  });

  @override
  State<AnimatedImageSlider> createState() => _AnimatedImageSliderState();
}

class _AnimatedImageSliderState extends State<AnimatedImageSlider> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay && widget.images.length > 1) {
      _timer = Timer.periodic(widget.interval, (_) {
        if (!mounted) return;
        setState(() => _index = (_index + 1) % widget.images.length);
        widget.onIndexChanged?.call(_index);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final img = widget.images[_index];
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        ),
        child: KeyedSubtree(key: ValueKey(img), child: ImageAny(img)),
      ),
    );
  }
}
