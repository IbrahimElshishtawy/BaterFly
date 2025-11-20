// ignore_for_file: use_build_context_synchronously

import 'package:baterfly/app/core/widgets/site_app_bar/search_box.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'index.dart';

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool transparent;
  final String title;

  const SiteAppBar({
    super.key,
    this.transparent = false,
    this.title = 'ButteryFly',
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    // ✅ نخلي الديسكتوب من 1280 وطالع عشان يكون فيه مساحة كفاية
    final isWide = w >= 1280;
    final bg = transparent ? Colors.transparent : const Color(0xFF0E1A2A);

    return AppBar(
      backgroundColor: bg,
      elevation: transparent ? 0 : 2,
      automaticallyImplyLeading: false,
      centerTitle: true,
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

      // ✅ نخلي كل روابط الديسكتوب في Row واحد داخل Action واحدة
      actions: [
        if (isWide)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _desktopLinks(context),
            ),
          )
        else
          ..._mobileActions(context),
      ],
    );
  }

  /// روابط الديسكتوب
  List<Widget> _desktopLinks(BuildContext context) => [
    NavLink(text: 'الرئيسية', route: '/'),
    const SizedBox(width: 12),
    NavLink(text: 'تتبع منتجك', route: '/track'),
    const SizedBox(width: 16),

    // 🔹 SearchBox يفتح صفحة البحث
    SizedBox(
      width: 240, // ✅ نحدد عرض ثابت معقول عشان ما يكبر بزيادة
      child: SearchBox(onTap: () => _go(context, '/search')),
    ),

    const SizedBox(width: 16),
    WebButton(
      label: 'دخول الأدمن',
      icon: Icons.admin_panel_settings_outlined,
      onTap: () => _go(context, '/admin/login'),
    ),
  ];

  /// أكشنات الموبايل (بحث + منيو)
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

    if (!context.mounted) return;

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
