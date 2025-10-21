import 'package:flutter/material.dart';
import '../../../data/datasources/remote/products_remote.dart';
import '../../../data/models/product_model.dart';
import '../../../core/routing/app_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _remote = ProductsRemote();
  late Future<List<ProductModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _remote.fetchActive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: FutureBuilder<List<ProductModel>>(
        future: _future,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(child: Text('خطأ: ${s.error}'));
          }
          final items = s.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('لا توجد منتجات حالياً'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => _ProductCard(p: items[i]),
          );
        },
      ),
    );
  }
}
