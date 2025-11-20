// ignore_for_file: deprecated_member_use, file_names

import 'package:baterfly/app/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.2),
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const ListTile(
            title: Center(
              child: Text(
                'الأقسام',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white30),

          _drawerItem(
            context,
            icon: Icons.cached_outlined,
            title: 'سياسة الاستبدال والاسترجاع',
            route: AppRoutes.returns,
          ),
          _drawerItem(
            context,
            icon: Icons.local_shipping_outlined,
            title: 'سياسة الشحن',
            route: AppRoutes.shipping,
          ),
          _drawerItem(
            context,
            icon: Icons.mail_outline_rounded,
            title: 'تتبع الطلب',
            route: AppRoutes.track,
          ),
          _drawerItem(
            context,
            icon: Icons.support_agent_outlined,
            title: 'التواصل مع الدعم',
            route: AppRoutes.support,
          ),
          _drawerItem(
            context,
            icon: Icons.admin_panel_settings_outlined,
            title: 'دخول الأدمن',
            route: AppRoutes.adminLogin,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      hoverColor: Colors.white.withOpacity(0.1),
    );
  }
}
