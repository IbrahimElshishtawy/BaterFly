import 'package:flutter/material.dart';
import '../../checkout/pages/checkout_page.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Hero(
            tag: product['image'],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product['image'],
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(product['name'], style: AppTextStyles.title),
          const SizedBox(height: 8),
          Text(
            '${product['price']} ج.م',
            style: const TextStyle(fontSize: 20, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            product['desc'],
            style: AppTextStyles.subtitle.copyWith(height: 1.6),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CheckoutPage(product: product)),
            ),
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            label: const Text('اشترِ الآن', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
