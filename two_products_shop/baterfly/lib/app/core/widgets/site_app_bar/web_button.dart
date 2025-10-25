import 'package:flutter/material.dart';

class WebButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const WebButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<WebButton> createState() => _WebButtonState();
}

class _WebButtonState extends State<WebButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final bg = _down
        ? const Color(0xFF1F2A3A)
        : (_hover ? const Color(0xFF1B2433) : const Color(0x191C2736));
    final border = _hover ? const Color(0x3340A9FF) : const Color(0x221C86FF);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _down = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
            boxShadow: _hover
                ? const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
