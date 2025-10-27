// lib/app/features/product/widgets/product_details.dart
import 'package:baterfly/app/features/product/widgets/section_card.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final double w;
  final double maxW;
  final EdgeInsets pad;
  final String desc;
  final String usage;
  final List<String> features;
  final List<String> ingredients;

  const ProductDetails({
    super.key,
    required this.w,
    required this.maxW,
    required this.pad,
    required this.desc,
    required this.usage,
    required this.features,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    if (w >= 1024) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                SectionCard(
                  icon: Icons.description_outlined,
                  title: 'وصف المنتج',
                  child: Text(
                    desc.isEmpty ? 'وصف المنتج غير متوفر' : desc,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SectionCard(
                  icon: Icons.rule_outlined,
                  title: 'طريقة الاستخدام',
                  child: Text(
                    usage.trim().isEmpty ? 'غير متوفر' : usage,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              children: [
                SectionCard(
                  icon: Icons.workspace_premium_outlined,
                  title: 'مميزات المنتج',
                  child: features.isEmpty
                      ? const Text(
                          'غير متوفر',
                          style: TextStyle(color: Colors.white),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: features.map((t) => _bullet(t)).toList(),
                        ),
                ),
                SectionCard(
                  icon: Icons.science_outlined,
                  title: 'المكونات',
                  child: ingredients.isEmpty
                      ? const Text(
                          'غير متوفر',
                          style: TextStyle(color: Colors.white),
                        )
                      : Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: ingredients
                              .map(
                                (e) => Chip(
                                  label: Text(e),
                                  backgroundColor: const Color(0x1422D1FF),
                                  side: const BorderSide(
                                    color: Color(0x3322D1FF),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SectionCard(
            icon: Icons.description_outlined,
            title: 'وصف المنتج',
            child: Text(
              desc.isEmpty ? 'غير متوفر' : desc,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SectionCard(
            icon: Icons.rule_outlined,
            title: 'طريقة الاستخدام',
            child: Text(
              usage.trim().isEmpty ? 'غير متوفر' : usage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SectionCard(
            icon: Icons.workspace_premium_outlined,
            title: 'مميزات المنتج',
            child: features.isEmpty
                ? const Text('غير متوفر', style: TextStyle(color: Colors.white))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: features.map((t) => _bullet(t)).toList(),
                  ),
          ),
          SectionCard(
            icon: Icons.science_outlined,
            title: 'المكونات',
            child: ingredients.isEmpty
                ? const Text('غير متوفر', style: TextStyle(color: Colors.white))
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ingredients
                        .map(
                          (e) => Chip(
                            label: Text(e),
                            backgroundColor: const Color(0x1422D1FF),
                            side: const BorderSide(color: Color(0x3322D1FF)),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      );
    }
  }

  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: const [
          Icon(Icons.check_circle, size: 18, color: Color(0xFF22D1FF)),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
