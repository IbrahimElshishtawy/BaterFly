// ignore_for_file: duplicate_ignore, unnecessary_underscores

import 'package:flutter/material.dart';
import 'dart:async';

class ImageAny extends StatelessWidget {
  final String src;
  const ImageAny(this.src, {super.key});

  bool get _isNet => src.startsWith('http://') || src.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNet) {
      return Image.network(
        src,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _err(),
        loadingBuilder: (ctx, child, p) => p == null
            ? child
            : const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
      );
    }
    // أصول محلية من assets
    return Image.asset(
      src,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => _err(),
    );
  }

  Widget _err() => Container(
    color: const Color(0x11000000),
    alignment: Alignment.center,
    child: const Icon(
      Icons.broken_image_outlined,
      size: 36,
      color: Colors.black45,
    ),
  );
}

// ignore_for_file: file_names
// ignore_for_file: file_names
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
        setState(() {
          _index = (_index + 1) % widget.images.length;
        });
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
