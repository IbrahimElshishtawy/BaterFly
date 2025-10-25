import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final VoidCallback onTap;
  const SearchBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 38,
        constraints: const BoxConstraints(minWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x22FFFFFF)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              'ابحث عن منتج...',
              style: TextStyle(
                color: Colors.white.withOpacity(.70),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
