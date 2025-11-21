// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

class ProductImages extends StatelessWidget {
  final List<String> available;
  final List<String> selected;
  final Function(String) onToggle;

  const ProductImages({
    super.key,
    required this.available,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('صور المنتج', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),

        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemCount: selected.length,
            itemBuilder: (_, i) {
              final img = selected[i];
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(img, width: 110, fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: GestureDetector(
                      onTap: () => onToggle(img),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        const Text('اختيار من الصور المتاحة'),
        const SizedBox(height: 8),

        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 1,
          physics: const NeverScrollableScrollPhysics(),
          children: available.map((path) {
            final isSel = selected.contains(path);
            return GestureDetector(
              onTap: () => onToggle(path),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(path, fit: BoxFit.cover),
                  ),
                  if (isSel)
                    const Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(Icons.check_circle, color: Colors.blueAccent),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
