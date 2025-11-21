import 'package:flutter/material.dart';
import '../controllers/product_controllers.dart';

class ProductForm extends StatelessWidget {
  final ProductControllers c;

  const ProductForm({super.key, required this.c});

  Widget field(TextEditingController ctrl, String label, {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: lines,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        field(c.name, 'اسم المنتج'),
        field(c.slug, 'Slug'),
        field(c.type, 'نوع المنتج'),
        field(c.price, 'السعر'),
        field(c.desc, 'وصف المنتج', lines: 3),
        field(c.country, 'بلد المنشأ'),
        field(c.guarantee, 'الضمان'),

        field(c.mainBenefits, 'أهم المميزات', lines: 3),
        field(c.ingredients, 'المكونات', lines: 3),
        field(c.usage, 'خطوات الاستخدام', lines: 3),
        field(c.safety, 'تحذيرات', lines: 3),
        field(c.targetAudience, 'الجمهور المستهدف', lines: 3),
        field(c.marketing, 'جمل تسويقية', lines: 3),
        field(c.storage, 'نصائح التخزين', lines: 3),
        field(c.highlights, 'مميزات إضافية', lines: 3),
      ],
    );
  }
}
