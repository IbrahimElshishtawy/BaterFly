import 'package:flutter/material.dart';
import '../config/app_icons.dart';

class AppFooter extends StatelessWidget {
  final String about;
  final String policies;
  final VoidCallback onWhatsapp;
  final VoidCallback onFacebook;
  final VoidCallback onInstagram;
  const AppFooter({
    super.key,
    required this.about,
    required this.policies,
    required this.onWhatsapp,
    required this.onFacebook,
    required this.onInstagram,
    required String facebookUrl,
    required String whatsappUrl,
    required String instagramUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('عن المتجر', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(about, textAlign: TextAlign.start),
          const SizedBox(height: 16),
          Text('السياسات', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(policies, textAlign: TextAlign.start),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: onWhatsapp,
                tooltip: 'WhatsApp',
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.facebook),
                onPressed: onFacebook,
                tooltip: 'Facebook',
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(AppIcons.cart),
                onPressed: onInstagram,
                tooltip: 'Instagram',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '© لمسة حرير',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
