// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterColHeader extends StatelessWidget {
  final String text;
  const FooterColHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: Colors.white.withOpacity(0.92),
      fontWeight: FontWeight.w800,
      fontSize: 14,
      letterSpacing: .2,
    ),
  );
}

class FooterMuted extends StatelessWidget {
  final String text;
  const FooterMuted(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Colors.white.withOpacity(0.70),
      height: 1.6,
    ),
  );
}

class FooterLink extends StatefulWidget {
  final String text;
  final String url;
  const FooterLink({super.key, required this.text, required this.url});

  @override
  State<FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<FooterLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Colors.white.withOpacity(_hover ? 1 : 0.85),
      fontWeight: FontWeight.w600,
    );
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(
          Uri.parse(widget.url),
          mode: LaunchMode.externalApplication,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(_hover ? .9 : 0),
                width: 1.2,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(widget.text, style: style),
          ),
        ),
      ),
    );
  }
}
