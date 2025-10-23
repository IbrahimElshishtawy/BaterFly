import 'package:flutter/material.dart';
import '../../checkout/pages/checkout_page.dart';

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
              borderRadius: BorderRadius.circular(20),
              child: Image.network(product['image'], fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            product['name'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            product['price'],
            style: const TextStyle(
              fontSize: 20,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            product['desc'],
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutPage(product: product),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('اشتري الآن'),
          ),
        ],
      ),
    );
  }
}
