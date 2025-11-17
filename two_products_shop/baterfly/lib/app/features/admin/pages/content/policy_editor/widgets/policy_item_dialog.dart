// features/admin/content/policy/widgets/policy_item_dialog.dart

import 'package:flutter/material.dart';
import 'package:baterfly/app/data/models/policy_models.dart';

Future<PolicyItemModel?> showPolicyItemDialog({
  required BuildContext context,
  PolicyItemModel? existing,
}) {
  final isEdit = existing != null;

  final numberCtrl = TextEditingController(text: existing?.number ?? '');
  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final bodyCtrl = TextEditingController(text: existing?.body ?? '');

  return showDialog<PolicyItemModel>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(isEdit ? 'تعديل بند' : 'إضافة بند جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: numberCtrl,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  labelText: 'رقم البند (اختياري)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleCtrl,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(labelText: 'عنوان البند'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bodyCtrl,
                textDirection: TextDirection.rtl,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'نص البند'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty ||
                  bodyCtrl.text.trim().isEmpty) {
                return;
              }
              final updated = PolicyItemModel(
                id: existing?.id,
                number: numberCtrl.text.trim().isEmpty
                    ? null
                    : numberCtrl.text.trim(),
                title: titleCtrl.text.trim(),
                body: bodyCtrl.text.trim(),
              );
              Navigator.of(ctx).pop(updated);
            },
            child: Text(isEdit ? 'حفظ' : 'إضافة'),
          ),
        ],
      );
    },
  );
}
