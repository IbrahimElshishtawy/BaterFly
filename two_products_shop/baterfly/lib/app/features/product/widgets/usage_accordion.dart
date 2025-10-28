import 'package:flutter/material.dart';

class UsageAccordion extends StatefulWidget {
  final String text;
  const UsageAccordion({required this.text});

  @override
  State<UsageAccordion> createState() => _UsageAccordionState();
}

class _UsageAccordionState extends State<UsageAccordion> {
  bool open = true;

  List<String> _steps(String raw) {
    final cleaned = raw.replaceAll('\r', ' ').trim();
    final parts = cleaned.contains('\n')
        ? cleaned.split('\n')
        : cleaned.split(RegExp(r'[\.؛;]|،'));
    return parts
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .map((l) => l.replaceFirst(RegExp(r'^[0-9٠-٩]+\s*[\)\.\-:]*\s*'), ''))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps(widget.text);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x0FFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x2233C7FF)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => open = !open),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.toc, color: Color(0xFF9BE8FF)),
                  SizedBox(width: 8),
                  Text(
                    'عرض/إخفاء الخطوات',
                    style: TextStyle(color: Colors.white, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),
          if (open) const Divider(color: Color(0x2233C7FF), height: 1),
          if (open)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: List.generate(steps.length, (i) {
                  final n = i + 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepBadge(n: n),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: const TextStyle(
                              color: Colors.white,
                              height: 1.6,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  final int n;
  const _StepBadge({required this.n});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF22D1FF).withOpacity(.18),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0x3322D1FF)),
      ),
      child: Text(
        '$n',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
