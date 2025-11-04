// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'index.dart';

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool transparent;
  final String title; // 🔹 العنوان اللي هيظهر في النص

  const SiteAppBar({
    super.key,
    this.transparent = false,
    this.title = 'BatteryFly',
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
      elevation: transparent ? 0 : 2,
      automaticallyImplyLeading: false,
      centerTitle: true, // 🔹 يخلي النص في النص
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF4B9EFF), Color(0xFFFF7A00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// 🔹 الأكشنز اللي في اليمين واليسار (زي السلة أو المينيو)
      leadingWidth: 120,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          children: [
            InkWell(
              onTap: () => _go(context, '/'),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Icon(LucideIcons.droplets, color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                  const Text(
                    'BFly',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
        if (isWide) ..._desktopLinks(context) else ..._mobileActions(context),
      ],
    );
  }

  /// 🔹 روابط الويب (لما الشاشة تكون كبيرة)
  List<Widget> _desktopLinks(BuildContext context) => [
    NavLink(text: 'الرئيسية', onTap: () => _go(context, '/'), route: '/'),
    NavLink(
      text: 'اتصل بنا',
      onTap: () => _go(context, '/contact'),
      route: '/contact',
    ),
    const SizedBox(width: 8),
    SearchBox(onTap: () => _openSearch(context)),
    const SizedBox(width: 8),
    const SizedBox(width: 8),
    WebButton(
      label: 'دخول الأدمن',
      icon: Icons.admin_panel_settings_outlined,
      onTap: () => _go(context, '/admin/login'),
    ),
    const SizedBox(width: 12),
  ];

  /// 🔹 أكشنات الموبايل (بحث - سلة - مينيو)
  List<Widget> _mobileActions(BuildContext context) => [
    IconButton(
      tooltip: 'بحث',
      onPressed: () => _openSearch(context),
      icon: const Icon(Icons.search, color: Colors.white),
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
