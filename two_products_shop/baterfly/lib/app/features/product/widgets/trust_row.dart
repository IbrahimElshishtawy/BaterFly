import 'package:flutter/material.dart';

class TrustRow extends StatelessWidget {
  const TrustRow({super.key});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData ic, String t, [String? sub]) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x101ED4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x2233C7FF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ic, size: 18, color: const Color(0xFF9BE8FF)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (sub != null)
                Text(
                  sub,
                  style: const TextStyle(
                    color: Color(0xFFB9C6D3),
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 10,
      spacing: 10,
      children: [
        item(Icons.star_rate_rounded, 'تقييم 4.9/5', '+1,200 مراجعة'),
        item(Icons.verified_user_outlined, 'ضمان استرجاع', '14 يومًا'),
        item(Icons.local_shipping_outlined, 'شحن سريع', '2–5 أيام عمل'),
      ],
    );
  }
}
