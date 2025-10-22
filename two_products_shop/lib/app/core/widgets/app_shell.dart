import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenSearch;

  const AppShell({
    super.key,
    required this.child,
    this.onOpenCart,
    this.onOpenSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'متجرك',
          style: TextStyle(color: AppColors.textLight),
        ),
        actions: [
          IconButton(
            onPressed: onOpenSearch,
            icon: const Icon(Icons.search, color: AppColors.textLight),
          ),
          IconButton(
            onPressed: onOpenCart,
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.background,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: const [
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text('الرئيسية'),
              ),
              ListTile(
                leading: Icon(Icons.category_outlined),
                title: Text('التصنيفات'),
              ),
              ListTile(
                leading: Icon(Icons.receipt_long_outlined),
                title: Text('طلباتي'),
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('الإعدادات'),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: child,
      ),
    );
  }
}
