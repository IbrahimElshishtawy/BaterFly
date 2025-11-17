// features/admin/content/policy/widgets/policy_items_section.dart

// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:baterfly/app/data/models/policy_models.dart';

class PolicyItemsSection extends StatelessWidget {
  final List<PolicyItemModel> items;
  final VoidCallback onAddPressed;
  final void Function(PolicyItemModel) onEditPressed;
  final void Function(PolicyItemModel) onDeletePressed;

  const PolicyItemsSection({
    super.key,
    required this.items,
    required this.onAddPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'البنود التفصيلية',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add),
              label: const Text('إضافة بند'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text(
            'لا توجد بنود بعد. اضغط على "إضافة بند" لإضافة أول بند.',
            textDirection: TextDirection.rtl,
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              final prefix = item.number ?? (index + 1).toString();

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '$prefix - ${item.title}',
                  textDirection: TextDirection.rtl,
                ),
                subtitle: Text(
                  item.body,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'تعديل',
                      icon: const Icon(Icons.edit),
                      onPressed: () => onEditPressed(item),
                    ),
                    IconButton(
                      tooltip: 'حذف',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onDeletePressed(item),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
