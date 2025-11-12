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
                    leading:
                        p['image'] != null && (p['image'] as String).isNotEmpty
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
                            _openProductDialog(context, ctrl, product: p);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('حذف المنتج'),
                                content: Text(
                                  'هل أنت متأكد من حذف "${p['name'] ?? 'هذا المنتج'}"؟',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('إلغاء'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('حذف'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await ctrl.delete(p['id'] as int);
                            }
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
                _openProductDialog(context, ctrl);
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

/// Dialog لإضافة / تعديل منتج
Future<void> _openProductDialog(
  BuildContext context,
  ProductsController ctrl, {
  Map<String, dynamic>? product,
}) async {
  final isEdit = product != null;

  final nameCtrl = TextEditingController(
    text: product?['name']?.toString() ?? '',
  );
  final priceCtrl = TextEditingController(
    text: product?['price']?.toString() ?? '',
  );
  final imageCtrl = TextEditingController(
    text: product?['image']?.toString() ?? '',
  );

  final formKey = GlobalKey<FormState>();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      bool loading = false;

      late void Function(bool) setLoading;

      return StatefulBuilder(
        builder: (ctx, setState) {
          setLoading = (v) => setState(() => loading = v);

          return AlertDialog(
            title: Text(isEdit ? 'تعديل منتج' : 'إضافة منتج'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'اسم المنتج',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'أدخل اسم المنتج';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: priceCtrl,
                      decoration: const InputDecoration(
                        labelText: 'السعر (ج.م)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'أدخل السعر';
                        }
                        final parsed = double.tryParse(v);
                        if (parsed == null) return 'أدخل رقم صحيح';
                        if (parsed < 0) return 'السعر لا يمكن أن يكون سالبًا';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: imageCtrl,
                      decoration: const InputDecoration(
                        labelText: 'رابط الصورة (اختياري)',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setLoading(true);

                        final data = <String, dynamic>{
                          'name': nameCtrl.text.trim(),
                          'price': double.parse(priceCtrl.text.trim()),
                          'image': imageCtrl.text.trim().isEmpty
                              ? null
                              : imageCtrl.text.trim(),
                        };

                        try {
                          if (isEdit) {
                            await ctrl.update(product!['id'] as int, data);
                          } else {
                            await ctrl.create(data);
                          }
                          if (context.mounted) {
                            Navigator.pop(ctx);
                          }
                        } catch (e) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text('حدث خطأ: $e')),
                            );
                          }
                        } finally {
                          setLoading(false);
                        }
                      },
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEdit ? 'حفظ التعديل' : 'إضافة'),
              ),
            ],
          );
        },
      );
    },
  );
}
