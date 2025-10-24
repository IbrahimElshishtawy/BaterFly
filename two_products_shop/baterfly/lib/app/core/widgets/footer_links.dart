// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E1A2A), Color(0xFF0B1020)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final maxW = w >= 1440
                ? 1240.0
                : w >= 1280
                ? 1140.0
                : 1100.0;
            final hpad = w >= 1024
                ? 28.0
                : w >= 768
                ? 24.0
                : 16.0;
            final isWide = w >= 900;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: hpad),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // خط علوي رفيع
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.06),
                      ),
                      SizedBox(height: isWide ? 22 : 16),

                      // مناطق الروابط
                      isWide ? _DesktopColumns() : const _MobileColumns(),

                      const SizedBox(height: 18),
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.06),
                      ),
                      const SizedBox(height: 12),

                      // شريط سفلي: سوشيال + أدمن + حقوق
                      Wrap(
                        spacing: 14,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          _IconLink(
                            url: 'https://facebook.com',
                            icon: Icons.facebook,
                          ),
                          _IconLink(
                            url: 'https://instagram.com',
                            icon: Icons.camera_alt_outlined,
                          ),
                          _IconLink(
                            url: 'https://wa.me/201234567890',
                            icon: Icons.chat_outlined,
                          ),

                          // فاصل
                          Container(
                            width: 1,
                            height: 18,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            color: Colors.white.withOpacity(0.10),
                          ),

                          _WebButton(
                            label: 'دخول الأدمن',
                            icon: Icons.admin_panel_settings_outlined,
                            onTap: () =>
                                Navigator.pushNamed(context, '/admin/login'),
                          ),

                          // فاصل
                          Container(
                            width: 1,
                            height: 18,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            color: Colors.white.withOpacity(0.10),
                          ),

                          Text(
                            '© 2025 لمسة حرير',
                            style: t.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.72),
                              letterSpacing: .1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// تخطيط سطح مكتب: ثلاثة أعمدة
class _DesktopColumns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colTitle = TextStyle(
      color: Colors.white.withOpacity(0.92),
      fontWeight: FontWeight.w800,
      fontSize: 14,
      letterSpacing: .2,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عمود معلومات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('لمسة حرير', style: colTitle),
              const SizedBox(height: 10),
              _Muted('منتجات عناية واكسسوارات مختارة بعناية.'),
              _Muted('شحن سريع داخل مصر واسترجاع خلال 14 يوم.'),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // عمود سياسات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ColHeader('السياسات'),
              SizedBox(height: 10),
              _Link(
                text: 'سياسة الاستبدال والاسترجاع',
                url: 'https://example.com/returns',
              ),
              _Link(text: 'سياسة الشحن', url: 'https://example.com/shipping'),
              _Link(text: 'الأسئلة الشائعة', url: 'https://example.com/faq'),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // عمود الدعم
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ColHeader('الدعم والتواصل'),
              SizedBox(height: 10),
              _Link(
                text: 'الدعم الفني واتساب',
                url: 'https://wa.me/201234567890',
              ),
              _Link(text: 'فيسبوك', url: 'https://facebook.com'),
              _Link(text: 'إنستغرام', url: 'https://instagram.com'),
            ],
          ),
        ),
      ],
    );
  }
}

/// تخطيط موبايل: أقسام فوق بعض
class _MobileColumns extends StatelessWidget {
  const _MobileColumns();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // سطر موجز
        const _Muted('منتجات عناية واكسسوارات مختارة بعناية.'),
        const SizedBox(height: 8),
        const _Muted('شحن سريع داخل مصر واسترجاع خلال 14 يوم.'),

        const SizedBox(height: 16),

        Wrap(
          spacing: 18,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: const [
            _Link(
              text: 'سياسة الاستبدال والاسترجاع',
              url: 'https://example.com/returns',
            ),
            _Link(text: 'سياسة الشحن', url: 'https://example.com/shipping'),
            _Link(
              text: 'الدعم الفني واتساب',
              url: 'https://wa.me/201234567890',
            ),
          ],
        ),
      ],
    );
  }
}

// ----- أجزاء مساعدة -----

class _ColHeader extends StatelessWidget {
  final String text;
  const _ColHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.92),
        fontWeight: FontWeight.w800,
        fontSize: 14,
        letterSpacing: .2,
      ),
    );
  }
}

class _Muted extends StatelessWidget {
  final String text;
  const _Muted(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Colors.white.withOpacity(0.70),
        height: 1.6,
      ),
    );
  }
}

class _Link extends StatefulWidget {
  final String text;
  final String url;
  const _Link({required this.text, required this.url});

  @override
  State<_Link> createState() => _LinkState();
}

class _LinkState extends State<_Link> {
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
                color: Colors.white.withOpacity(_hover ? .9 : .0),
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

class _IconLink extends StatefulWidget {
  final String url;
  final IconData icon;
  const _IconLink({required this.url, required this.icon});

  @override
  State<_IconLink> createState() => _IconLinkState();
}

class _IconLinkState extends State<_IconLink> {
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

class _WebButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _WebButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_WebButton> createState() => _WebButtonState();
}

class _WebButtonState extends State<_WebButton> {
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
              const Text(
                'أدمن', // نص الزر الظاهر
                style: TextStyle(
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
