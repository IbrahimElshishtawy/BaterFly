// lib/app/features/search/pages/search_page.dart

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

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _service = ProductService();

  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String? _categorySlug;
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;

  late Future<List<ProductModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<ProductModel>> _load() {
    return _service.searchProducts(
      query: _query,
      categorySlug: _categorySlug,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minRating: _minRating,
    );
  }

  void _runSearch() {
    setState(() {
      _future = _load();
    });
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        double tempMinPrice = _minPrice ?? 0;
        double tempMaxPrice = _maxPrice ?? 1000;
        double tempMinRating = _minRating ?? 0;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'فلترة النتائج',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // مثال لسعر
                  const Text(
                    'نطاق السعر',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: _filterInputDecoration('أقل سعر'),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (v) {
                            setModalState(() {
                              tempMinPrice =
                                  double.tryParse(v.trim()) ?? tempMinPrice;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: _filterInputDecoration('أعلى سعر'),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (v) {
                            setModalState(() {
                              tempMaxPrice =
                                  double.tryParse(v.trim()) ?? tempMaxPrice;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'أقل تقييم',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: tempMinRating,
                          min: 0,
                          max: 5,
                          divisions: 5,
                          label: tempMinRating.toStringAsFixed(1),
                          onChanged: (val) {
                            setModalState(() {
                              tempMinRating = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tempMinRating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _minPrice = tempMinPrice;
                        _maxPrice = tempMaxPrice;
                        _minRating = tempMinRating;
                        _future = _load();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('تطبيق الفلاتر'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _minPrice = null;
                        _maxPrice = null;
                        _minRating = null;
                        _categorySlug = null;
                        _future = _load();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'إزالة كل الفلاتر',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _filterInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 13),
      filled: true,
      fillColor: Colors.white.withOpacity(.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.orangeAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(
        transparent: false,
        // ممكن تضيف SearchBox هنا كـ action
      ),
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
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'حدث خطأ أثناء البحث عن المنتجات',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final products = snapshot.data ?? [];

                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // شريط البحث + زر الفلاتر
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 16, side, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'ابحث عن منتج...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(.6),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black.withOpacity(0.30),
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white.withOpacity(.85),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _query = val.trim();
                                      _future = _load();
                                    });
                                  },
                                  onSubmitted: (_) => _runSearch(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: _openFilterBottomSheet,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black.withOpacity(.35),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(.25),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.filter_list_rounded,
                                        color: Colors.white.withOpacity(.9),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'فلتر',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // عدد النتائج
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 4, side, 12),
                          child: Text(
                            'عدد النتائج: ${products.length}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),

                      // شبكة المنتجات
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
