// features/admin/products/widgets/product_form_fields.dart

import 'package:flutter/material.dart';

class ProductFormFields extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController slugCtrl;
  final TextEditingController typeCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController descCtrl;
  final TextEditingController countryCtrl;
  final TextEditingController guaranteeCtrl;

  final TextEditingController mainBenefitsCtrl;
  final TextEditingController ingredientsCtrl;
  final TextEditingController usageCtrl;
  final TextEditingController safetyCtrl;
  final TextEditingController targetAudienceCtrl;
  final TextEditingController marketingCtrl;
  final TextEditingController storageCtrl;
  final TextEditingController highlightsCtrl;

  const ProductFormFields({
    super.key,
    required this.nameCtrl,
    required this.slugCtrl,
    required this.typeCtrl,
    required this.priceCtrl,
    required this.descCtrl,
    required this.countryCtrl,
    required this.guaranteeCtrl,
    required this.mainBenefitsCtrl,
    required this.ingredientsCtrl,
    required this.usageCtrl,
    required this.safetyCtrl,
    required this.targetAudienceCtrl,
    required this.marketingCtrl,
    required this.storageCtrl,
    required this.highlightsCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(nameCtrl, 'اسم المنتج'),
        const SizedBox(height: 10),
        _buildTextField(slugCtrl, 'Slug (عنوان الرابط)'),
        const SizedBox(height: 10),
        _buildTextField(typeCtrl, 'نوع / وصف قصير'),
        const SizedBox(height: 10),
        _buildTextField(
          priceCtrl,
          'السعر',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 10),
        _buildTextField(descCtrl, 'وصف المنتج', maxLines: 4),
        const SizedBox(height: 10),
        _buildTextField(countryCtrl, 'بلد المنشأ'),
        const SizedBox(height: 10),
        _buildTextField(guaranteeCtrl, 'الضمان'),
        const SizedBox(height: 20),
        _buildMultilineListField(
          controller: mainBenefitsCtrl,
          label: 'أهم المميزات (سطر لكل ميزة)',
        ),
        const SizedBox(height: 10),
        _buildMultilineListField(
          controller: ingredientsCtrl,
          label: 'المكونات (سطر لكل عنصر)',
        ),
        const SizedBox(height: 10),
        _buildMultilineListField(
          controller: usageCtrl,
          label: 'طريقة الاستخدام (سطر لكل خطوة)',
        ),
        const SizedBox(height: 10),
        _buildMultilineListField(
          controller: safetyCtrl,
          label: 'الأمان / التحذيرات (سطر لكل نقطة)',
        ),
        const SizedBox(height: 10),
        _buildMultilineListField(
          controller: targetAudienceCtrl,
          label: 'الفئة المستهدفة (سطر لكل نوع عميل)',
        ),
        const SizedBox(height: 10),
        _buildMultilineListField(
          controller: marketingCtrl,
          label: 'جمل تسويقية (سطر لكل جملة)',
        ),
        const SizedBox(height: 10),
        _buildMultilineListField(
          controller: storageCtrl,
          label: 'نصائح التخزين (سطر لكل نقطة)',
        ),
        const SizedBox(height: 10),
        _buildMultilineListField(
          controller: highlightsCtrl,
          label: 'مميزات إضافية (سطر لكل نقطة)',
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ).copyWith(labelText: label),
    );
  }

  Widget _buildMultilineListField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      maxLines: null,
      minLines: 3,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'كل سطر يمثل عنصر في القائمة.',
      ).copyWith(labelText: label, alignLabelWithHint: true),
    );
  }
}
