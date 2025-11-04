import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:flutter/material.dart';

import '../sections/product_title.dart';
import '../sections/product_details.dart';
import '../sections/price_and_cta.dart';
import '../widgets/gradient_bg.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ProductTitle(),
                    ProductDetails(),
                    PriceAndCTA(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: FooterLinks()),
            ],
          ),
        ],
      ),
    );
  }
}
