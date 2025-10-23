import 'package:flutter/material.dart';
import '../../checkout/pages/checkout_page.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product['name']),
              background: Hero(
                tag: product['image'],
                child: Image.network(product['image'], fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['price'],
                    style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      product['desc'],
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(product: product),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('اشتري الآن'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
