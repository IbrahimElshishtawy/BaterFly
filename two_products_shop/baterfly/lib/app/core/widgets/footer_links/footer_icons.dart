import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterIconLink extends StatefulWidget {
  final String url;
  final IconData icon;
  const FooterIconLink({super.key, required this.url, required this.icon});

  @override
  State<FooterIconLink> createState() => _FooterIconLinkState();
}

class _FooterIconLinkState extends State<FooterIconLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(_hover ? .95 : .85);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: InkResponse(
        onTap: () => launchUrl(
          Uri.parse(widget.url),
          mode: LaunchMode.externalApplication,
        ),
        radius: 22,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _hover ? Colors.white.withOpacity(0.08) : Colors.transparent,
          ),
          child: Icon(widget.icon, size: 20, color: color),
        ),
      ),
    );
  }
}
