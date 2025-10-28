// ignore_for_file: unnecessary_underscores

import 'dart:async';
import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/data/models/Cart_Item.dart';
import 'package:baterfly/app/domain/entities/product.dart';
import 'package:baterfly/app/features/checkout/pages/checkout_page.dart';
import 'package:baterfly/app/features/product/sections/price_and_cta.dart';
import 'package:baterfly/app/features/product/sections/product_details.dart';
import 'package:baterfly/app/features/product/sections/product_title.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<String> _images = const [
    'assets/images/image_1.jpg',
    'assets/images/image_2.jpg',
    'assets/images/image_3.jpg',
    'assets/images/image_4.jpg',
  ];

  int _current = 0;
  late final PageController _pageController;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoSlide());
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final curr = _pageController.page?.round() ?? _current;
      final next = (curr + 1) % _images.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() => _current = next);
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.product['name'] as String;
    final price = (widget.product['price'] as num).toDouble();
    final desc = (widget.product['desc'] ?? '') as String;
    final rating = ((widget.product['avg_rating'] ?? 0) as num).toDouble();
    final reviews = (widget.product['reviews_count'] ?? 0) as int;
    final usage = (widget.product['usage'] ?? '') as String;
    final features =
        (widget.product['features'] as List?)?.cast<String>() ??
        const <String>[];
    final ingredients =
        (widget.product['ingredients'] as List?)?.cast<String>() ??
        const <String>[];

    return Scaffold(
      appBar: const SiteAppBar(transparent: false),
      body: LayoutBuilder(
        builder: (context, cons) {
          final w = cons.maxWidth;
          final pad = EdgeInsets.symmetric(horizontal: w * 0.05);
          final heroH = w * 0.60;

          return Stack(
            children: [
              const GradientBackground(),
              CustomScrollView(
                slivers: [
                  // ===== السلايدر =====
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: pad.copyWith(top: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(
                          height: heroH,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: _images.length,
                                onPageChanged: (i) =>
                                    setState(() => _current = i),
                                itemBuilder: (context, i) => GestureDetector(
                                  onTap: () => _openGallery(context, i),
                                  onPanDown: (_) => _autoSlideTimer?.cancel(),
                                  onPanCancel: _startAutoSlide,
                                  onPanEnd: (_) => _startAutoSlide(),
                                  child: Hero(
                                    tag: 'image_$i',
                                    child: Image.asset(
                                      _images[i],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: heroH,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _images.length,
                                    (i) => AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: _current == i ? 16 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _current == i
                                            ? Colors.white
                                            : Colors.white54,
                                        borderRadius: BorderRadius.circular(6),
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
                  ),

                  // ===== المصغّرات =====
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: pad.copyWith(top: 10),
                      child: SizedBox(
                        height: 78,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, i) => InkWell(
                            onTap: () {
                              _autoSlideTimer?.cancel();
                              _pageController.animateToPage(
                                i,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                              setState(() => _current = i);
                              _startAutoSlide();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _current == i
                                      ? Colors.tealAccent
                                      : Colors.white24,
                                  width: _current == i ? 2 : 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(_images[i], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ===== السعر و CTA =====
                  SliverToBoxAdapter(
                    child: PriceAndCTA(
                      price: price,
                      rating: rating,
                      reviews: reviews,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CheckoutPage(product: widget.product),
                          ),
                        );
                      },
                    ),
                  ),

                  // ===== العنوان =====
                  SliverToBoxAdapter(child: ProductTitle(name: name)),

                  // ===== التفاصيل =====
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: pad,
                      // داخل build لنفس الشاشة
                      child: ProductDetails(
                        w: w,
                        maxW: w * 0.9,
                        pad: pad,
                        desc: desc,
                        usage: usage,
                        features: features,
                        ingredients: ingredients,
                        onAddToCart: () {
                          CartService.I.add(
                            widget.product as Product,
                            qty: 1,
                          ); // الإضافة فعليًا
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تمت الإضافة للسلة')),
                          );
                        },
                      ),
                    ),
                  ),

                  // ===== Footer منظم =====
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 24, bottom: 32),
                      child: const FooterLinks(),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openGallery(BuildContext context, int initialIndex) async {
    _autoSlideTimer?.cancel();
    await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: _images.length,
                pageController: PageController(initialPage: initialIndex),
                builder: (_, i) => PhotoViewGalleryPageOptions(
                  heroAttributes: PhotoViewHeroAttributes(tag: 'image_$i'),
                  imageProvider: AssetImage(_images[i]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.8,
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
    if (mounted) _startAutoSlide();
  }
}
