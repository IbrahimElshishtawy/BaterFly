// features/admin/content/policy/widgets/policy_page_form.dart

import 'package:flutter/material.dart';

class PolicyPageForm extends StatelessWidget {
  final TextEditingController mainTitleController;
  final TextEditingController introController;
  final TextEditingController noteController;

  const PolicyPageForm({
    super.key,
    required this.mainTitleController,
    required this.introController,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: mainTitleController,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            labelText: 'العنوان الرئيسي في الصفحة',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: introController,
          textDirection: TextDirection.rtl,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'النص التمهيدي (الفقرة الأولى)',
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: noteController,
          textDirection: TextDirection.rtl,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'ملاحظة ختامية / تنبيه مهم',
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }
}
