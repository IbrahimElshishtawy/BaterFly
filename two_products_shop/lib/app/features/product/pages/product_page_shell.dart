import 'package:flutter/material.dart';
import '../../../data/datasources/remote/products_remote.dart';
import '../../../data/models/product_model.dart';
// احذف السطر التالي لو مفيش الويدجت ده عندك
import '../widgets/usage_section.dart';

class ProductPageShell extends StatelessWidget {
  final String productId;
  const ProductPageShell({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المنتج'), centerTitle: true),
      body: FutureBuilder<ProductModel?>(
        future: ProductsRemote().getById(productId),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('حدث خطأ: ${snap.error}'));
          }
          final p = snap.data;
          if (p == null) {
            return const Center(child: Text('المنتج غير موجود'));
          }
          final img =
              (p.imageUrl is String && (p.imageUrl as String).isNotEmpty)
              ? p.imageUrl as String
              : null;
          final title = p.title;
          final description = p.description ?? '';
          final priceText = '${p.price} EGP';

          return SinglePageLayout(
            image: img,
            title: title,
            description: description,
            priceText: priceText,
            colorScheme: cs,
          );
        },
      ),
    );
  }
}

class SinglePageLayout extends StatelessWidget {
  final String? image;
  final String title;
  final String description;
  final String priceText;
  final ColorScheme colorScheme;

  const SinglePageLayout({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.priceText,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'p-img-$title', // لو عندك id استخدمه بدلاً من العنوان
            child: AspectRatio(
              aspectRatio: 1.6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: (image != null)
                    ? Image.network(image!, fit: BoxFit.cover)
                    : const ColoredBox(color: Color(0xFFE9EEF5)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                priceText,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: colorScheme.primary),
              ),
              const Spacer(),
              // تم حذف أي استخدام لـ rating لأنه غير موجود في الموديل عندك
            ],
          ),
          const SizedBox(height: 16),

          if (description.isNotEmpty) ...[
            Text('الوصف', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
          ],

          // احذف هذا القسم لو الويدجت مش متوفر عندك
          const UsageSection(),

          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              // أضف منطق الإضافة للسلة هنا عند جاهزيته
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت الإضافة إلى السلة')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('إضافة إلى السلة'),
          ),
        ],
      ),
    );
  }
}
