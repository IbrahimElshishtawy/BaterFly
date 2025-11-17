// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/services/supabase/Product_Service.dart';
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

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // نقرأ الـ slug من الـ arguments اللي جاي من Navigator.pushNamed
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final slug = args?['slug'] as String?;

    if (slug == null || slug.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'لم يتم تمرير معرف المنتج (slug)',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

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
                return const Center(
                  child: Text(
                    'حدث خطأ أثناء تحميل بيانات المنتج',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final product = snapshot.data;
              if (product == null) {
                return const Center(
                  child: Text(
                    'لم يتم العثور على هذا المنتج',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // صور المنتج من الموديل
                        ProductImages(images: product.images),

                        // السعر والزرار (لو حابب تمرر product بعدين عدّل الـ widget ده)
                        const PriceAndCTA(),

                        // عنوان المنتج والوصف وغيره
                        ProductTitle(product: product),

                        // تفاصيل المنتج (مميزات، مكونات، استخدام، أمان...)
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
