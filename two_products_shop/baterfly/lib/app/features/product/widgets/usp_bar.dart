import 'package:flutter/material.dart';

class USPBar extends StatelessWidget {
  const USPBar();

  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.flash_on_outlined, 'نتيجة فورية'),
      (Icons.health_and_safety_outlined, 'آمن بدون فورمالين'),
      (Icons.opacity_outlined, 'ترطيب عميق'),
      (Icons.bolt_outlined, 'تقوية الألياف'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0x0FFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      child: LayoutBuilder(
        builder: (_, c) {
          final tight = c.maxWidth < 640;
          return Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 8,
            spacing: 8,
            children: items.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x1422D1FF),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0x3322D1FF)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(e.$1, size: 16, color: const Color(0xFF22D1FF)),
                    const SizedBox(width: 6),
                    Text(
                      e.$2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: tight ? 12 : 13.5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
