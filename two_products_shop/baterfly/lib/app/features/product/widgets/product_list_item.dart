import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProductListItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  const ProductListItem({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product['image'],
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        product['name'],
        style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        product['desc'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '${product['price']} ج.م',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
