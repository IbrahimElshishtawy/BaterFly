import 'package:flutter/material.dart';
import '../../product/pages/product_page.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'id': 1,
        'name': 'Brazilian Keratin Protein',
        'price': 'EGP 950',
        'image':
            'https://images.unsplash.com/photo-1596464716121-7b6b60fbb33c?w=800',
        'desc':
            'بروتين برازيلي لفرد الشعر وتغذيته من الجذور. يمنحك لمعان وقوة وحيوية طبيعية.',
      },
      {
        'id': 2,
        'name': 'Argan Oil Hair Treatment',
        'price': 'EGP 780',
        'image':
            'https://images.unsplash.com/photo-1600180758890-6c1d0a92c14e?w=800',
        'desc':
            'علاج غني بزيت الأرجان المغربي لتغذية الشعر الجاف والمجهد وإعادة لمعانه الطبيعي.',
      },
      {
        'id': 3,
        'name': 'Cocoa Hair Protein',
        'price': 'EGP 850',
        'image':
            'https://images.unsplash.com/photo-1601049676869-702ea24cfd91?w=800',
        'desc':
            'بروتين الكاكاو لتنعيم الشعر الخشن وترميم التقصف، مناسب لجميع أنواع الشعر.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('منتجات بروتين الشعر'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // على الويب 3 أعمدة
          childAspectRatio: .75,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return ProductCard(
            name: p['name']!,
            price: p['price']!,
            image: p['image']!,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProductPage(product: p)),
              );
            },
          );
        },
      ),
    );
  }
}
