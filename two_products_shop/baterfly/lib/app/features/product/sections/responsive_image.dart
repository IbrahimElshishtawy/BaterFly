// lib/app/features/product/widgets/responsive_image.dart
import 'package:flutter/material.dart';

class ResponsiveImage extends StatelessWidget {
  final String img;
  final double height;
  const ResponsiveImage({super.key, required this.img, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              img,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0x11000000),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image_outlined,
                  size: 40,
                  color: Colors.white70,
                ),
              ),
              loadingBuilder: (ctx, child, p) => p == null
                  ? child
                  : const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
            ),
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
                  stops: [0, .5, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
