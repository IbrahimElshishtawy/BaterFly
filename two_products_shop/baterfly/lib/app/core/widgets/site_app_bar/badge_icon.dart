import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final int count;

  const BadgeIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    final btn = IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
    );
    if (count <= 0) return btn;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        btn,
        PositionedDirectional(
          top: 8,
          end: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
