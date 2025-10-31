import 'package:flutter/material.dart';

class SafetyList extends StatelessWidget {
  final List<String> items;
  const SafetyList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((t) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFF9BE8FF),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    t,
                    style: const TextStyle(
                      color: Color(0xFFDFE8F2),
                      height: 1.5,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
