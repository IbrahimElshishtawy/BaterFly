// features/admin/products/widgets/product_images_section.dart

// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';

class ProductImagesSection extends StatelessWidget {
  final List<String> availableImages;
  final List<String> selectedImages;
  final void Function(String path) onToggle;

  const ProductImagesSection({
    super.key,
    required this.availableImages,
    required this.selectedImages,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صور المنتج',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        // الصور المختارة الآن
        SizedBox(
          height: 140,
          child: selectedImages.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Text(
                    'لم يتم اختيار صور بعد',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final path = selectedImages[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            path,
                            width: 110,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: InkWell(
                            onTap: () => onToggle(path),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
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
        const Text(
          'اختيار من الصور المتاحة',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 260,
          child: GridView.builder(
            itemCount: availableImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, index) {
              final path = availableImages[index];
              final isSelected = selectedImages.contains(path);

              return GestureDetector(
                onTap: () => onToggle(path),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.transparent,
                          width: 3,
                        ),
                        color: isSelected
                            ? Colors.black26
                            : Colors.black12.withOpacity(0),
                      ),
                    ),
                    if (isSelected)
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.lightBlueAccent,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
