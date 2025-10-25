import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../core/widgets/footer_links.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 60),
            Text(
              'اتصل بنا',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('📞 الهاتف: +965 9999 9999'),
            Text('✉️ البريد الإلكتروني: info@lamor.com'),
            Text('📍 العنوان: الكويت - شارع الخليج العربي'),
          ],
        ),
      ),
      bottomNavigationBar: const FooterLinks(),
    );
  }
}
