// pages/widgets/reviews_list.dart
import 'package:flutter/material.dart';

class ReviewsList extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final bool isWide;
  final bool isTablet;
  final Future<void> Function(int id, bool val) onToggleVerified;

  const ReviewsList({
    super.key,
    required this.reviews,
    required this.isWide,
    required this.isTablet,
    required this.onToggleVerified,
  });

  Color _statusColor(bool verified) => verified ? Colors.green : Colors.orange;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(isTablet || isWide ? 16 : 8),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: reviews.length,
      itemBuilder: (context, i) {
        final r = reviews[i];
        final bool isVerified = r['is_verified'] == true;
        final statusColor = _statusColor(isVerified);

        return Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            title: Text(
              r['product_name'] ?? 'منتج غير معروف',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  'Order: ${r['order_no'] ?? '-'}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Rating: ⭐ ${r['rating'] ?? 0}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                if ((r['comment'] ?? '').toString().isNotEmpty)
                  Text(r['comment'], style: const TextStyle(fontSize: 13)),
              ],
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min, // 👈 يمنع overflow
              mainAxisAlignment: MainAxisAlignment.center, // 👈 في النص
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isVerified ? 'مُوثَّق' : 'غير مُوثَّق',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Transform.scale(
                  scale: 0.9, // تصغير بسيط للـ Switch
                  child: Switch(
                    value: isVerified,
                    onChanged: (val) => onToggleVerified(r['id'] as int, val),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
