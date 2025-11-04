// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'animated_image_slider.dart';
import 'image_any.dart';
import 'dots.dart';

class ProductCard extends StatefulWidget {
  final List<String> images;
  final double? rating;
  final double? price;
  final double topRadius;
  final bool autoPlay;
  final Duration interval;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.images,
    this.rating,
    this.price,
    this.topRadius = 13,
    this.autoPlay = true,
    this.interval = const Duration(seconds: 3),
    this.onTap,
    required AnimatedImageSlider imageWidget,
    required Text priceWidget,
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
            AnimatedImageSlider(
              images: imgs,
              interval: widget.interval,
              borderRadius: widget.topRadius,
              autoPlay: widget.autoPlay,
              onIndexChanged: (i) => setState(() => _index = i),
            )
          else
            ImageAny(imgs.first),

          // 🔹 التقييم أو "جديد"
          PositionedDirectional(
            top: 8,
            start: 8,
            child: _badge(
              context,
              filled: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.rating != null && widget.rating! > 0)
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Colors.amber,
                    ),
                  if (widget.rating != null && widget.rating! > 0)
                    const SizedBox(width: 4),
                  Text(
                    widget.rating != null && widget.rating! > 0
                        ? widget.rating!.toStringAsFixed(1)
                        : 'جديد',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 السعر أو "اطلب الآن"
          if (widget.price != null)
            PositionedDirectional(
              bottom: 8,
              end: 8,
              child: _badge(
                context,
                filled: true,
                child: Text(
                  '${widget.price!.toStringAsFixed(0)} ج.م',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          if (imgs.length > 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Dots(count: imgs.length, index: _index),
              ),
            ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
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
