import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  final String? url;
  final double? height;
  const ImageLoader({super.key, this.url, this.height});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        height: height ?? 180,
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.image_not_supported)),
      );
    }
    return Image.network(
      url!,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        height: height ?? 180,
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.broken_image)),
      ),
    );
  }
}
