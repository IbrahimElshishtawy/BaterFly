// pages/widgets/reviews_filter_bar.dart
import 'package:flutter/material.dart';

class ReviewsFilterBar extends StatelessWidget {
  final String currentFilter; // all / verified / unverified
  final ValueChanged<String> onFilterChanged;

  const ReviewsFilterBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('الكل'),
            selected: currentFilter == 'all',
            onSelected: (_) => onFilterChanged('all'),
            selectedColor: Colors.deepPurple.shade50,
            labelStyle: TextStyle(
              color: currentFilter == 'all'
                  ? Colors.deepPurple
                  : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('الموثّق فقط'),
            selected: currentFilter == 'verified',
            onSelected: (_) => onFilterChanged('verified'),
            selectedColor: Colors.green.withOpacity(0.12),
            labelStyle: TextStyle(
              color: currentFilter == 'verified'
                  ? Colors.green
                  : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('غير الموثّق'),
            selected: currentFilter == 'unverified',
            onSelected: (_) => onFilterChanged('unverified'),
            selectedColor: Colors.orange.withOpacity(0.12),
            labelStyle: TextStyle(
              color: currentFilter == 'unverified'
                  ? Colors.orange
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
