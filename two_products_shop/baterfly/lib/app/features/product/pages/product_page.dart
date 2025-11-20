// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';

import 'package:baterfly/app/features/product/sections/Product_Images.dart';
import 'package:baterfly/app/features/product/sections/product_title.dart';
import 'package:baterfly/app/features/product/sections/product_details.dart';
import 'package:baterfly/app/features/product/sections/price_and_cta.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';

import 'package:baterfly/app/data/models/product_model.dart';
import 'package:baterfly/app/services/supabase/product_service.dart';

class ProductPage extends StatefulWidget {
  final String slug;

  const ProductPage({super.key, required this.slug});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _productService = ProductService();
  late Future<ProductModel?> _future;

  @override
  void initState() {
    super.initState();
    _future = _productService.getProductBySlug(widget.slug);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _productService.getProductBySlug(widget.slug);
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          FutureBuilder<ProductModel?>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                // ignore: avoid_print
                print('ProductPage error: ${snapshot.error}');
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'حدث خطأ أثناء تحميل بيانات المنتج:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _refresh,
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final product = snapshot.data;

              if (product == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'المنتج غير موجود في قاعدة البيانات.\nslug = ${widget.slug}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _refresh,
                          icon: const Icon(Icons.refresh),
                          label: const Text('تحديث'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductImages(images: product.images),

                          // لو الـ PriceAndCTA بيحتاج product مرّره هنا
                          // PriceAndCTA(product: product),
                          const PriceAndCTA(),

                          ProductTitle(product: product),
                          ProductDetails(product: product),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(child: FooterLinks()),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
