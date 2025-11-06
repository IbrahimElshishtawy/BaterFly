// pages/admin_dashboard_page.dart
import 'package:baterfly/app/features/admin/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'orders_page.dart';
import 'reviews_page.dart';
import 'settings_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selected = 0;

  final _pages = const [
    OrdersPage(),
    ProductsPage(),
    ReviewsPage(),
    SettingsPage(),
  ];

  final _titles = ['الطلبات', 'المنتجات', 'التقييمات', 'الإعدادات'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('لوحة الأدمن — ${_titles[_selected]}')),
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selected,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (i) => setState(() => _selected = i),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long),
                label: Text('الطلبات'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2),
                label: Text('المنتجات'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.rate_review),
                label: Text('التقييمات'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('الإعدادات'),
              ),
            ],
          ),

          const VerticalDivider(width: 1),
          // Content
          Expanded(child: _pages[_selected]),
        ],
      ),
    );
  }
}
