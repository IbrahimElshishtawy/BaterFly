// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class NavLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const NavLink({super.key, required this.text, required this.onTap});

  @override
  State<NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(_hover ? .95 : 0),
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white.withOpacity(_hover ? 1 : .88),
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              letterSpacing: .2,
            ),
          ),
        ),
      ),
    );
  }
}
