// lib/app/features/catalog/widgets/product_card/product_card.dart
// ignore_for_file: unnecessary_underscores

import 'dart:async';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final List<String> images;
  final double? rating;
  final double? price;
  final double topRadius;

  final bool autoPlay;
  final Duration interval;

  final VoidCallback? onTap; // ← جديد

  const ProductCard({
    super.key,
    required this.images,
    this.rating,
    this.price,
    this.topRadius = 13,
    this.autoPlay = true,
    this.interval = const Duration(seconds: 3),
    this.onTap, // ← جديد
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _index = 0;

  List<String> get _imgs {
    final xs = widget.images
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return xs.isEmpty
        ? const [
            'assets/images/image_1.jpg',
            'assets/images/image_2.jpg',
            'assets/images/image_3.jpg',
            'assets/images/image_4.jpg',
          ]
        : xs;
  }

  @override
  Widget build(BuildContext context) {
    final imgs = _imgs;

    final content = ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(widget.topRadius),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imgs.length > 1)
            _AnimatedImageSlider(
              images: imgs,
              interval: widget.interval,
              borderRadius: widget.topRadius,
              autoPlay: widget.autoPlay,
              onIndexChanged: (i) => setState(() => _index = i),
            )
          else
            _ImageAny(imgs.first),

          if (widget.rating != null)
            PositionedDirectional(
              top: 8,
              start: 8,
              child: _badge(
                context,
                child: const Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFFFFC107),
                    ),
                    SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          if (widget.rating != null)
            PositionedDirectional(
              top: 8,
              start: 36,
              child: _badge(
                context,
                child: Text(
                  widget.rating!.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),

          if (widget.price != null)
            PositionedDirectional(
              bottom: 8,
              end: 8,
              child: _badge(
                context,
                filled: true,
                child: Text(
                  '${widget.price!.toStringAsFixed(0)} ج.م',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),

          if (imgs.length > 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _Dots(count: imgs.length, index: _index),
              ),
            ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap, // ← هنا
        borderRadius: BorderRadius.circular(widget.topRadius),
        child: content,
      ),
    );
  }

  Widget _badge(
    BuildContext context, {
    required Widget child,
    bool filled = false,
  }) {
    final bg = filled ? Theme.of(context).colorScheme.primary : Colors.white;
    final fg = filled ? Colors.white : Colors.black.withOpacity(0.8);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? bg : bg.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: filled ? bg : Colors.black12),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(fontSize: 12, color: fg),
        child: child,
      ),
    );
  }
}

/// ===== Helpers =====
class _ImageAny extends StatelessWidget {
  final String src;
  const _ImageAny(this.src);

  bool get _isNet {
    final u = Uri.tryParse(src);
    return u != null && (u.scheme == 'http' || u.scheme == 'https');
  }

  String get _resolvedAsset {
    if (src.startsWith('assets/')) return src;
    if (_isNet) return src;
    return 'assets/images/$src';
  }

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
    return Image.asset(
      _resolvedAsset,
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

class _AnimatedImageSlider extends StatefulWidget {
  final List<String> images;
  final Duration interval;
  final double borderRadius;
  final bool autoPlay;
  final ValueChanged<int>? onIndexChanged;

  const _AnimatedImageSlider({
    required this.images,
    this.interval = const Duration(seconds: 3),
    this.borderRadius = 12,
    this.autoPlay = true,
    this.onIndexChanged,
  });

  @override
  State<_AnimatedImageSlider> createState() => _AnimatedImageSliderState();
}

class _AnimatedImageSliderState extends State<_AnimatedImageSlider> {
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
        child: KeyedSubtree(key: ValueKey(img), child: _ImageAny(img)),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: i == index ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(i == index ? .95 : .45),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
