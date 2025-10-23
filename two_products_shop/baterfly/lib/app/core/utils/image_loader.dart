// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  const ImageLoader({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const Icon(Icons.image_not_supported, color: Colors.grey);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      ),
    );
  }
}
