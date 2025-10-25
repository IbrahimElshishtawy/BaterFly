import 'package:flutter/material.dart';
import '../../../core/widgets/footer_links/footer_links.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SiteAppBar(),
      bottomNavigationBar: FooterLinks(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'تواصل معنا عبر واتساب أو البريد الإلكتروني لأي استفسار.',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
      ),
    );
  }
}
