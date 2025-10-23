import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType type;
  final bool multiline;
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.type = TextInputType.text,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: multiline ? TextInputType.multiline : type,
      maxLines: multiline ? null : 1,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
