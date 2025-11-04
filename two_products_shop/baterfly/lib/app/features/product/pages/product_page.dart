import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/features/product/controllers/product_controller.dart';
import 'package:baterfly/app/features/product/sections/price_and_cta.dart';
import 'package:baterfly/app/features/product/sections/product_details.dart';
import 'package:baterfly/app/features/product/sections/product_title.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductPage extends StatelessWidget {
  final int productId;
  const ProductPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    controller.fetchProduct(productId);

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final product = controller.product;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: ProductTitle(product: product)),
                SliverToBoxAdapter(child: ProductDetails(product: product)),
                SliverToBoxAdapter(child: PriceAndCTA(product: product)),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
                const SliverToBoxAdapter(child: FooterLinks()),
              ],
            );
          }),
        ],
      ),
    );
  }
}
