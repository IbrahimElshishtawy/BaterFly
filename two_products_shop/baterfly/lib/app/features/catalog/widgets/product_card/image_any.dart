// lib/app/features/catalog/widgets/product_card/image_any.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

class ImageAny extends StatelessWidget {
  final String src;
  const ImageAny(this.src, {super.key});

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
