// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

import 'package:baterfly/app/services/supabase/Product_Service.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';

import 'package:baterfly/app/features/catalog/widgets/HomeReviewsSection.dart';
import 'package:baterfly/app/features/catalog/widgets/product_card/animated_image_slider.dart';
import 'package:baterfly/app/features/catalog/widgets/widget/build_video_Section.dart';
import 'package:baterfly/app/features/reviews/widgets/review_section.dart';

import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:baterfly/app/features/product/widgets/product_hover.dart';
import 'package:baterfly/app/features/catalog/widgets/product_card/product_card.dart';

import 'package:baterfly/app/data/models/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = ProductService();
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _service.getActiveProducts();
  }

  int _cols(double w) {
    if (w >= 1600) return 6;
    if (w >= 1300) return 5;
    if (w >= 992) return 4;
    if (w >= 720) return 3;
    if (w >= 520) return 2;
    return 1;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _futureProducts = _service.getActiveProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          RefreshIndicator(
            onRefresh: _onRefresh,
            child: FutureBuilder<List<ProductModel>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'حدث خطأ أثناء تحميل المنتجات',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                return LayoutBuilder(
                  builder: (_, constraints) {
                    final w = constraints.maxWidth;
                    final pad = Responsive.hpad(w);
                    final maxW = Responsive.maxWidth(w);
                    final cols = _cols(w);

                    double side = (w - maxW) / 2;
                    final minSide = pad.horizontal / 2;
                    if (side < minSide) side = minSide;

                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(side, 16, side, 16),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: cols,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: .78,
                                ),
                            delegate: SliverChildBuilderDelegate((context, i) {
                              if (i >= products.length) return null;

                              final product = products[i];
                              final images = product.images;

                              // لو لسه السعر مش موجود في الداتا، سيبه null مؤقتًا
                              final double? price = product.price == 0
                                  ? null
                                  : product.price;
                              final double rating = product.avgRating == 0
                                  ? 4.5
                                  : product.avgRating;

                              return SizedBox(
                                height: 260,
                                child: ProductHover(
                                  child: ProductCard(
                                    images: images,
                                    price: price,
                                    rating: rating,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.product, // أو '/product'
                                        arguments: {
                                          'slug': product.slug,
                                          'id': product.id,
                                        },
                                      );
                                    },
                                    imageWidget: AnimatedImageSlider(
                                      images: images,
                                    ),
                                    priceWidget: Text(
                                      price != null
                                          ? '\$${price.toStringAsFixed(2)}'
                                          : 'N/A',
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: products.length),
                          ),
                        ),

                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: BuildVideoSection(),
                          ),
                        ),

                        const HomeReviewsSection(),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 24,
                            ),
                            child: ReviewSection(
                              orderNo: 'HOME_SECTION',
                              productName: products.isNotEmpty
                                  ? products.first.name
                                  : 'المنتج',
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(child: FooterLinks()),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
