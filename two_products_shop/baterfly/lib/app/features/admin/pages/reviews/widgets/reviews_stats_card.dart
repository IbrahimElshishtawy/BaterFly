// pages/widgets/reviews_stats_card.dart
import 'package:flutter/material.dart';

class ReviewsStatsCard extends StatelessWidget {
  final int total;
  final int verified;
  final int unverified;
  final bool isWide;

  const ReviewsStatsCard({
    super.key,
    required this.total,
    required this.verified,
    required this.unverified,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: isWide
              ? Row(
                  children: [
                    Expanded(child: _totalColumn()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statChip(
                            label: 'الموثّق',
                            value: verified,
                            color: Colors.green,
                          ),
                          _statChip(
                            label: 'غير الموثّق',
                            value: unverified,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _totalColumn(),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _statChip(
                          label: 'الموثّق',
                          value: verified,
                          color: Colors.green,
                        ),
                        _statChip(
                          label: 'غير الموثّق',
                          value: unverified,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // -----------------------------
  //   إجمالي التقييمات
  // -----------------------------
  Widget _totalColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إجمالي التقييمات',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          '$total',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // -----------------------------
  //   الكروت الصغيرة (Stat Chips)
  // -----------------------------
  Widget _statChip({
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
