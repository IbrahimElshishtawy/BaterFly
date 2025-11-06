// pages/products_page.dart
import 'package:flutter/material.dart';
import '../controllers/products_controller.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductsController()..load(),
      child: Consumer<ProductsController>(
        builder: (context, ctrl, _) {
          if (ctrl.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ctrl.products.length,
              itemBuilder: (context, i) {
                final p = ctrl.products[i];
                return Card(
                  child: ListTile(
                    leading: p['image'] != null
                        ? Image.network(
                            p['image'],
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(width: 56, height: 56),
                    title: Text(p['name'] ?? 'بدون اسم'),
                    subtitle: Text('${p['price'] ?? '-'} ج.م'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // open edit dialog (implement)
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await ctrl.delete(p['id'] as int);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // open add product dialog (implement)
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
