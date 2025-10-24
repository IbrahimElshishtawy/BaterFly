// lib/app/widgets/site_app_bar.dart
// ignore_for_file: deprecated_member_use, unused_element_parameter, unnecessary_import, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool transparent; // شفاف فوق هيرو أو خلفية
  const SiteAppBar({
    super.key,
    this.transparent = false,
    required void Function() onOpenMenu,
    required Future<Null> Function() onSearchTap,
    required Future<Object?> Function() onOpenCart,
    required Future<Object?> Function() onAdmin,
    required Future<Object?> Function() onLogoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 1024;

    final bg = transparent ? Colors.transparent : const Color(0xFF0E1A2A);

    return AppBar(
      backgroundColor: bg,
      elevation: transparent ? 0 : 1,
      centerTitle: false,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 16),
        child: Row(
          children: [
            // شعار + رجوع للصفحة الرئيسية
            InkWell(
              onTap: () => _go(context, '/'),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: const [
                  Icon(Icons.blur_on, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'لمسة حرير',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .3,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // سطح مكتب: روابط + حقل بحث + سلة + زر أدمن
            if (isWide) ...[
              _NavLink(text: 'الرئيسية', onTap: () => _go(context, '/')),
              _NavLink(text: 'المنتجات', onTap: () => _go(context, '/catalog')),
              _NavLink(text: 'العروض', onTap: () => _go(context, '/offers')),
              _NavLink(text: 'اتصل بنا', onTap: () => _go(context, '/contact')),
              const SizedBox(width: 8),
              _SearchBox(onTap: () => _openSearch(context)),
              const SizedBox(width: 8),
              _BadgeIcon(
                icon: Icons.shopping_bag_outlined,
                tooltip: 'السلة',
                onTap: () => _go(context, '/cart'),
              ),
              const SizedBox(width: 8),
              _WebButton(
                label: 'دخول الأدمن',
                icon: Icons.admin_panel_settings_outlined,
                onTap: () => _go(context, '/admin/login'),
              ),
            ],

            // موبايل: بحث + سلة + قائمة
            if (!isWide) ...[
              IconButton(
                tooltip: 'بحث',
                onPressed: () => _openSearch(context),
                icon: const Icon(Icons.search, color: Colors.white),
              ),
              IconButton(
                tooltip: 'السلة',
                onPressed: () => _go(context, '/cart'),
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
              ),
              Builder(
                // Builder يضمن وجود Scaffold في السياق
                builder: (c) => IconButton(
                  tooltip: 'القائمة',
                  onPressed: () => _openEndDrawer(c),
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // فتح البحث الافتراضي
  Future<void> _openSearch(BuildContext context) async {
    final res = await showSearch<String?>(
      context: context,
      delegate: _SimpleSearchDelegate(),
    );
    if (res != null && res.trim().isNotEmpty) {
      _go(context, '/catalog', args: {'q': res.trim()});
    }
  }

  // فتح الـ EndDrawer إن وجد
  void _openEndDrawer(BuildContext context) {
    final s = Scaffold.maybeOf(context);
    if (s != null && s.hasEndDrawer) {
      s.openEndDrawer();
    }
  }

  // تنقّل آمن. يتجنب تكديس نفس الصفحة إن أمكن.
  void _go(BuildContext context, String route, {Object? args}) {
    final current = ModalRoute.of(context)?.settings.name;
    if (current == route) return;
    Navigator.pushNamed(context, route, arguments: args);
  }
}

// ----------------- عناصر مساعدة -----------------

class _NavLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _NavLink({required this.text, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
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
                color: Colors.white.withOpacity(_hover ? .95 : .0),
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

class _SearchBox extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchBox({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 38,
        constraints: const BoxConstraints(minWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x22FFFFFF)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              'ابحث عن منتج...',
              style: TextStyle(
                color: Colors.white.withOpacity(.70),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final int count;
  const _BadgeIcon({
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

// SearchDelegate افتراضي
class _SimpleSearchDelegate extends SearchDelegate<String?> {
  _SimpleSearchDelegate() {
    query = '';
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => _hint();
  @override
  Widget buildSuggestions(BuildContext context) => _hint();

  Widget _hint() => Center(child: Text('اكتب اسم المنتج ثم Enter: $query'));

  @override
  void showResults(BuildContext context) => close(context, query.trim());
}
