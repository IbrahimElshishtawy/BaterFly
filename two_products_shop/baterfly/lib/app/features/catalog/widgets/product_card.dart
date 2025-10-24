// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final double price;
  final double rating;

  /// يدعم رابطًا واحدًا أو عدة روابط مفصولة بفواصل
  final String image;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hover = false;
  late final PageController _pc = PageController();
  int _page = 0;

  List<String> get _imgs {
    final parts = widget.image
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return const ['https://via.placeholder.com/800x1000?text=Product'];
    }
    return parts;
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const radius = 14.0;
    final imgs = _imgs;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black12),
        boxShadow: _hover && kIsWeb
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // مساحة الصور: سلايدر تلقائي عند تعدد الصور
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imgs.length == 1)
                    _NetImage(imgs.first)
                  else
                    PageView.builder(
                      controller: _pc,
                      itemCount: imgs.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (_, i) => _NetImage(imgs[i]),
                    ),

                  // شارة التقييم
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
                            widget.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // شارة السعر
                  PositionedDirectional(
                    bottom: 8,
                    end: 8,
                    child: _badge(
                      context,
                      filled: true,
                      child: Text(
                        '${widget.price.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),

                  // مؤشرات سلايدر
                  if (imgs.length > 1)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _Dots(count: imgs.length, index: _page),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // نصوص
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: .3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.local_mall_outlined,
                      size: 14,
                      color: Theme.of(context).hintColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'متاح للشحن',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const Spacer(),
                    if (kIsWeb)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 120),
                        opacity: _hover ? 1 : 0.0,
                        child: const Icon(
                          Icons.arrow_outward_rounded,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(radius),
          child: kIsWeb
              ? AnimatedScale(
                  scale: _hover ? 1.015 : 1.0,
                  duration: const Duration(milliseconds: 140),
                  child: card,
                )
              : card,
        ),
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

/// صورة شبكة مع تحميل وخطأ موحّد
class _NetImage extends StatelessWidget {
  final String url;
  const _NetImage(this.url);

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

/// مؤشرات سلايدر بسيطة
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
