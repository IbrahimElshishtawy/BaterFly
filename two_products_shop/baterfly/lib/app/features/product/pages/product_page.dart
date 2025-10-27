// lib/app/features/product/pages/product_page.dart
import 'package:baterfly/app/features/product/sections/price_and_cta.dart';
import 'package:baterfly/app/features/product/sections/product_details.dart';
import 'package:baterfly/app/features/product/sections/product_title.dart';
import 'package:baterfly/app/features/product/sections/responsive_image.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../widgets/gradient_bg.dart';
import '../../checkout/pages/checkout_page.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String;
    final price = (product['price'] as num).toDouble();
    final desc = (product['desc'] ?? '') as String;
    final img =
        (product['image'] as String?) ??
        'https://via.placeholder.com/1600x900?text=Product';
    final rating = ((product['avg_rating'] ?? 0) as num).toDouble();
    final reviews = (product['reviews_count'] ?? 0) as int;
    final usage = (product['usage'] ?? '') as String;
    final features =
        (product['features'] as List?)?.cast<String>() ?? const <String>[];
    final ingredients =
        (product['ingredients'] as List?)?.cast<String>() ?? const <String>[];

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const SiteAppBar(transparent: false),
      body: LayoutBuilder(
        builder: (context, cons) {
          final w = cons.maxWidth;
          final pad = EdgeInsets.symmetric(horizontal: w * 0.05);
          final maxW = w * 0.9;
          final heroH = w * 0.4;

          return Stack(
            children: [
              const GradientBackground(),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Image Section
                  ResponsiveImage(img: img, height: heroH),

                  // Price and CTA
                  PriceAndCTA(
                    price: price,
                    rating: rating,
                    reviews: reviews,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutPage(product: product),
                        ),
                      );
                    },
                  ),

                  // Product Title
                  ProductTitle(name: name),

                  // Product Details
                  ProductDetails(
                    w: w,
                    maxW: maxW,
                    pad: pad,
                    desc: desc,
                    usage: usage,
                    features: features,
                    ingredients: ingredients,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
