import 'package:flutter/material.dart';

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GhostButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.shopping_bag_outlined,
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      style:
          OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Color(0x80FFFFFF), // لون الحدود خفيف
              width: 1.5,
            ),
            backgroundColor: const Color(0x00FFFFFF), // خلفية شفافة
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ), // تباعد جيد
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // زاوية أقل حدة للزر
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.all(
              const Color(0x22FFFFFF),
            ), // تأثير التمرير
          ),
    );
  }
}
