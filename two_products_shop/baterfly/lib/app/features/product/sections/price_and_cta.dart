import 'package:flutter/material.dart';
import '../widgets/section_card.dart';

class PriceAndCTA extends StatelessWidget {
  const PriceAndCTA({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "احجزي الآن واحصلي على نتائج فورية ✨",
      content: Column(
        children: [
          const Text(
            "السعر: 550 جنيه مصري",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "اطلبي الآن",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
