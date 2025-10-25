// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'index.dart';

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool transparent;
  const SiteAppBar({super.key, this.transparent = false});

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
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 16),
        child: Row(
          children: [
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
            if (isWide)
              ..._desktopLinks(context)
            else
              ..._mobileActions(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _desktopLinks(BuildContext context) => [
    NavLink(text: 'الرئيسية', onTap: () => _go(context, '/')),
    NavLink(text: 'اتصل بنا', onTap: () => _go(context, '/contact')),
    const SizedBox(width: 8),
    SearchBox(onTap: () => _openSearch(context)),
    const SizedBox(width: 8),
    BadgeIcon(
      icon: Icons.shopping_bag_outlined,
      tooltip: 'السلة',
      onTap: () => _go(context, '/cart'),
    ),
    const SizedBox(width: 8),
    WebButton(
      label: 'دخول الأدمن',
      icon: Icons.admin_panel_settings_outlined,
      onTap: () => _go(context, '/admin/login'),
    ),
  ];

  List<Widget> _mobileActions(BuildContext context) => [
    IconButton(
      tooltip: 'بحث',
      onPressed: () => _openSearch(context),
      icon: const Icon(Icons.search, color: Colors.white),
    ),
    IconButton(
      tooltip: 'السلة',
      onPressed: () => _go(context, '/cart'),
      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
    ),
    Builder(
      builder: (c) => IconButton(
        tooltip: 'القائمة',
        onPressed: () {
          final s = Scaffold.maybeOf(c);
          if (s != null && s.hasEndDrawer) s.openEndDrawer();
        },
        icon: const Icon(Icons.menu, color: Colors.white),
      ),
    ),
  ];

  Future<void> _openSearch(BuildContext context) async {
    final res = await showSearch<String?>(
      context: context,
      delegate: SimpleSearchDelegate(),
    );
    if (res != null && res.trim().isNotEmpty) {
      _go(context, '/catalog', args: {'q': res.trim()});
    }
  }

  void _go(BuildContext context, String route, {Object? args}) {
    final current = ModalRoute.of(context)?.settings.name;
    if (current == route) return;
    Navigator.pushNamed(context, route, arguments: args);
  }
}
