// features/admin/content/policy/widgets/policy_page_header.dart

import 'package:flutter/material.dart';

class PolicyPageHeader extends StatelessWidget {
  final String slug;
  final String label;

  const PolicyPageHeader({super.key, required this.slug, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = slug == 'shipping'
        ? Icons.local_shipping_outlined
        : Icons.assignment_return_outlined;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.indigo),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'تعديل العنوان والنص التمهيدي والملاحظة الختامية والبنود التفصيلية لهذه الصفحة.',
                textDirection: TextDirection.rtl,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
