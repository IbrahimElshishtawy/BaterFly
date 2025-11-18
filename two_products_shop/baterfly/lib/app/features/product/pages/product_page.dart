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

class ProductPage extends StatelessWidget {
  final String slug;

  const ProductPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          FutureBuilder<ProductModel?>(
            future: productService.getProductBySlug(slug),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                // ignore: avoid_print
                print('ProductPage error: ${snapshot.error}');
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    'حدث خطأ أثناء تحميل بيانات المنتج:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              final product = snapshot.data;

              if (product == null) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    'المنتج غير موجود في قاعدة البيانات.\nslug = $slug',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductImages(images: product.images),

                        PriceAndCTA(),

                        ProductTitle(product: product),
                        ProductDetails(product: product),

                        const SizedBox(height: 40),
                      ],
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
