// ignore_for_file: unnecessary_underscores

import 'dart:async';
import 'package:baterfly/app/features/catalog/widgets/product_card/Dots.dart';
import 'package:baterfly/app/features/catalog/widgets/product_card/Net_Image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final List<String> images; // http/https أو assets
  final double? rating;
  final double? price;
  final double topRadius;

  // إعدادات السلايدر
  final bool autoPlay;
  final Duration interval;
  final Duration slideDuration;
  final Curve slideCurve;

  const ProductCard({
    super.key,
    required this.images,
    this.rating,
    this.price,
    this.topRadius = 13,

    // افتراضيات آمنة
    this.autoPlay = true,
    this.interval = const Duration(seconds: 3),
    this.slideDuration = const Duration(milliseconds: 450),
    this.slideCurve = Curves.easeInOut,
  });

  @override
  State<ProductCard> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductCard> {
  late final PageController _pc = PageController();
  int _page = 0;
  Timer? _timer;

  List<String> get _imgs {
    final parts = widget.images
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return const ['https://via.placeholder.com/800x1000?text=Product'];
    }
    return parts;
  }

  @override
  void initState() {
    super.initState();
    _startAutoPlayIfNeeded();
  }

  void _startAutoPlayIfNeeded() {
    if (!widget.autoPlay) return;
    if (_imgs.length <= 1) return;

    // نضمن جاهزية الـ PageController بعد أول فريم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer?.cancel();
      _timer = Timer.periodic(widget.interval, (_) {
        if (!mounted) return;
        final next = (_page + 1) % _imgs.length;
        _pc.animateToPage(
          next,
          duration: widget.slideDuration,
          curve: widget.slideCurve,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imgs = _imgs;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(widget.topRadius),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imgs.length == 1)
            AnimatedImageSlider(imgs.first)
          else
            PageView.builder(
              controller: _pc,
              itemCount: imgs.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => ImageAny(imgs[i]),
            ),

          if (widget.rating != null)
            PositionedDirectional(
              top: 8,
              start: 8,
              child: _badge(
                context,
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFFFFC107),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.rating!.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
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
                child: Dots(count: imgs.length, index: _page),
              ),
            ),
        ],
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
