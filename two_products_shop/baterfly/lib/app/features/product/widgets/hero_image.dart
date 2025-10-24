// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

class HeroImage extends StatefulWidget {
  final String url;
  final double height;
  final double borderRadius;
  const HeroImage({
    super.key,
    required this.url,
    required this.height,
    this.borderRadius = 28,
  });

  @override
  State<HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final r = Radius.circular(widget.borderRadius);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.015 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? 0.25 : 0.18),
                blurRadius: _hover ? 28 : 18,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.url,
                  fit: BoxFit.cover,
                  frameBuilder: (ctx, child, frame, _) => AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 350),
                    child: child,
                  ),
                  loadingBuilder: (ctx, child, progress) => progress == null
                      ? child
                      : Container(
                          color: const Color(0x0DFFFFFF),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                  errorBuilder: (ctx, err, st) => Container(
                    color: const Color(0x11000000),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: Colors.white70,
                    ),
                  ),
                ),
                // Overlay تدرّج
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x22000000),
                        Color(0x00000000),
                        Color(0x33000000),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                // شارة صغيرة
                Positioned(
                  right: 12,
                  top: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.24),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.photo_camera_back_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'صورة المنتج',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
