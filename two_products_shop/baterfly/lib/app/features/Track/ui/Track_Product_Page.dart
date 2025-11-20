// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:baterfly/app/core/routing/app_routes.dart';
import 'package:baterfly/app/services/supabase/Product_Service.dart';

import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';

import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:baterfly/app/features/product/widgets/product_hover.dart';
import 'package:baterfly/app/features/catalog/widgets/product_card/product_card.dart';
import 'package:baterfly/app/features/catalog/widgets/product_card/animated_image_slider.dart';

import 'package:baterfly/app/data/models/product_model.dart';

class TrackProductPage extends StatefulWidget {
  const TrackProductPage({super.key});

  @override
  State<TrackProductPage> createState() => _TrackProductPageState();
}

class _TrackProductPageState extends State<TrackProductPage> {
  final _service = ProductService();

  final TextEditingController _nameController = TextEditingController();

  String _query = '';
  late Future<List<ProductModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.value(<ProductModel>[]);
  }

  int _cols(double w) {
    if (w >= 1600) return 6;
    if (w >= 1300) return 5;
    if (w >= 992) return 4;
    if (w >= 720) return 3;
    if (w >= 520) return 2;
    return 1;
  }

  void _runTrack() {
    setState(() {
      _future = _service.searchProducts(
        query: _query,
        // لو عندك باراميترات إضافية للفلترة ممكن تضيفها هنا
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: const SiteAppBar(transparent: false, title: 'تتبع منتجك'),
      body: Stack(
        children: [
          const GradientBackground(),
          LayoutBuilder(
            builder: (_, constraints) {
              final w = constraints.maxWidth;
              final pad = Responsive.hpad(w);
              final maxW = Responsive.maxWidth(w);
              final cols = _cols(w);

              double side = (w - maxW) / 2;
              final minSide = pad.horizontal / 2;
              if (side < minSide) side = minSide;

              return FutureBuilder<List<ProductModel>>(
                future: _future,
                builder: (context, snapshot) {
                  final loading =
                      snapshot.connectionState == ConnectionState.waiting;
                  final products = snapshot.data ?? [];

                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // 🔹 عنوان وتعليمات بسيطة
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 20, side, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'تتبع منتجك بالاسم',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'اكتب اسم المنتج أو جزء منه لمعرفة حالته وموقعه في المتجر.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 🔹 حقل إدخال الاسم + زر "تتبع"
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 8, side, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText:
                                        'مثال: سماعة بلوتوث، كيبورد ميكانيكال...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(.6),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black.withOpacity(0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.25),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.25),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white.withOpacity(.85),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.search,
                                  onChanged: (val) {
                                    _query = val.trim();
                                  },
                                  onSubmitted: (_) {
                                    _query = _nameController.text.trim();
                                    if (_query.isNotEmpty) _runTrack();
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _query = _nameController.text.trim();
                                  if (_query.isNotEmpty) _runTrack();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('تتبع'),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 🔹 حالة التحميل أو رسالة لا توجد نتائج
                      if (loading)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        )
                      else if (!loading &&
                          _query.isNotEmpty &&
                          products.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(side, 24, side, 16),
                            child: const Text(
                              'لا يوجد منتج مطابق للاسم المدخل حاليًا.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                      // 🔹 لو في نتائج – نعرضها في Grid مثل الهوم
                      if (products.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(side, 8, side, 4),
                            child: Text(
                              'عدد المنتجات المطابقة: ${products.length}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      if (products.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(side, 8, side, 16),
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
                                        AppRoutes.product,
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

                      // 🔹 FooterLinks في آخر الصفحة
                      const SliverToBoxAdapter(child: FooterLinks()),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
