// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/core/widgets/Reviews_Slider.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/data/models/review_model.dart';
import 'package:baterfly/app/data/static/product_data.dart';
import 'package:baterfly/app/features/catalog/widgets/product_card/animated_image_slider.dart';
import 'package:baterfly/app/features/catalog/widgets/widget/build_video_Section.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/responsive.dart';
import '../../../core/widgets/footer_links/footer_links.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../product/widgets/gradient_bg.dart';
import '../../product/widgets/product_hover.dart';
import '../widgets/product_card/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..forward();

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _loadLocalProducts() {
    return List.generate(1, (index) {
      return {
        'id': index + 1,
        'name': ProductData.name,
        'slug': 'ceramide-butterfly-$index',

        'avg_rating': 4.5,
        'reviews_count': 12,
        'active': true,
      };
    });
  }

  List<String> _getProductImages(int index) {
    final imgs = ProductData.images;
    return [
      imgs[index % imgs.length],
      imgs[(index + 1) % imgs.length],
      imgs[(index + 2) % imgs.length],
    ];
  }

  int _cols(double w) {
    if (w >= 1600) return 6;
    if (w >= 1300) return 5;
    if (w >= 992) return 4;
    if (w >= 720) return 3;
    if (w >= 520) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final items = _loadLocalProducts();
    final midIndex = (items.length / 2).floor();

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          LayoutBuilder(
            builder: (_, c) {
              final w = c.maxWidth;
              final pad = Responsive.hpad(w);
              final maxW = Responsive.maxWidth(w);
              final cols = _cols(w);
              double side = (w - maxW) / 2;
              final minSide = pad.horizontal / 2;
              if (side < minSide) side = minSide;

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(side, 16, side, 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: .78,
                      ),
                      delegate: SliverChildBuilderDelegate((context, i) {
                        if (i >= midIndex) return null;
                        final m = items[i];
                        final images = _getProductImages(i);
                        final price = (m['price'] as num?)?.toDouble();
                        final rating = ((m['avg_rating'] ?? 0) as num?)
                            ?.toDouble();

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
                                  '/product',
                                  arguments: {...m, 'images': images},
                                );
                              },
                              imageWidget: AnimatedImageSlider(images: images),
                              priceWidget: Text(
                                '\$${price?.toStringAsFixed(2) ?? 'N/A'}',
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }, childCount: midIndex),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: BuildVideoSection(),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(side, 16, side, 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: .78,
                      ),
                      delegate: SliverChildBuilderDelegate((context, i) {
                        final index = midIndex + i;
                        if (index >= items.length) return null;
                        final m = items[index];
                        final images = _getProductImages(index);
                        final rating = ((m['avg_rating'] ?? 0) as num?)
                            ?.toDouble();

                        return SizedBox(
                          height: 260,
                          child: ProductHover(
                            child: ProductCard(
                              images: images,
                              priceWidget: const Text(
                                'اطلب الآن',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              rating: rating,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/product',
                                  arguments: {...m, 'images': images},
                                );
                              },
                              imageWidget: AnimatedImageSlider(images: images),
                            ),
                          ),
                        );
                      }, childCount: items.length - midIndex),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: ReviewsSlider(
                          reviews: [
                            ReviewModel(
                              id: 1,
                              productId: 101,
                              fullName: "Ahmed",
                              rating: 5,
                              comment: "منتج رائع جدًا 👌",
                              isVerified: true,
                              status: "approved",
                            ),
                            ReviewModel(
                              id: 2,
                              productId: 102,
                              fullName: "Sara",
                              rating: 4,
                              comment: "جميل بس محتاج تحسين بسيط",
                              isVerified: false,
                              status: "pending",
                            ),
                            ReviewModel(
                              id: 3,
                              productId: 103,
                              fullName: "Omar",
                              rating: 5,
                              comment: "ممتاز أنصح بيه 🔥",
                              isVerified: true,
                              status: "approved",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: FooterLinks()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
