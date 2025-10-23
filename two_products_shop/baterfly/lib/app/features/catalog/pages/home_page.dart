import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../../product/pages/product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'id': 1,
        'name': 'كيراتين بروتين حرير برازيلي',
        'price': 950,
        'image': 'https://i.imgur.com/lHbHbTB.jpg',
        'desc': 'بروتين برازيلي لفرد وتغذية الشعر بتركيبة الكيراتين والأرجان.',
      },
      {
        'id': 2,
        'name': 'ماسك الكافيار للشعر التالف',
        'price': 480,
        'image': 'https://i.imgur.com/xkPEmj3.jpg',
        'desc': 'ترطيب عميق للشعر الجاف والتالف بفضل مستخلص الكافيار الطبيعي.',
      },
      {
        'id': 3,
        'name': 'سيروم اللمعان الفوري',
        'price': 220,
        'image': 'https://i.imgur.com/jjBQDcC.jpg',
        'desc': 'يمنح شعرك لمعانًا فوريًا ويحميه من الحرارة والعوامل الخارجية.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('متجر لمسة حرير'), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return ProductCard(
            name: p['name'],
            price: p['price'].toString(),
            image: p['image'],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductPage(product: p)),
            ),
          );
        },
      ),
    );
  }
}
