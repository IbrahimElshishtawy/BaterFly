import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: const Border(top: BorderSide(width: .6, color: Colors.black12)),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text('© لمسة حرير', style: style),
          Wrap(
            spacing: 12,
            children: [
              _link(
                'سياسة الاستبدال والاسترجاع',
                'https://example.com/returns',
                style,
              ),
              _link('سياسة الشحن', 'https://example.com/shipping', style),
              _link('الدعم', 'https://wa.me/201234567890', style),
            ],
          ),
          Wrap(
            spacing: 10,
            children: [
              _icon('https://facebook.com', Icons.facebook),
              _icon('https://instagram.com', Icons.camera_alt_outlined),
              _icon('https://wa.me/201234567890', Icons.chat_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _link(String t, String url, TextStyle? s) => InkWell(
    onTap: () =>
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    child: Text(t, style: s),
  );

  Widget _icon(String url, IconData i) => InkWell(
    onTap: () =>
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    child: Icon(i, size: 20),
  );
}
