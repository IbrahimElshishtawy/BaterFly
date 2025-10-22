import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String priceText;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.priceText,
    this.imageUrl,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'p-img-$id',
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: imageUrl != null
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : Container(color: const Color(0xFFE9EEF5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              priceText,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(.10),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'الأكثر طلبًا',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
