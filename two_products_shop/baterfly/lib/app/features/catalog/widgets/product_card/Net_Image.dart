import 'package:flutter/material.dart';

/// صورة شبكة مع تحميل وخطأ موحّد
class NetImage extends StatelessWidget {
  final String url;
  const NetImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0x11000000),
        alignment: Alignment.center,
        child: const Icon(
          Icons.broken_image_outlined,
          size: 36,
          color: Colors.black45,
        ),
      ),
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
}
