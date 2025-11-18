// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'order/orders_page.dart';
import 'reviews/reviews_page.dart';
import 'videos/videos_page.dart';
import 'content/content_admin_page.dart';
import 'products/products_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  int _selected = 0;
  late AnimationController _controller;
  late Animation<double> _fade;
  bool _disposed = false;
  late final List<Widget> _pages;

  final _titles = [
    'الطلبات',
    'المنتجات',
    'التقييمات',
    'الفيديوهات',
    'محتوى الصفحات',
  ];

  @override
  void initState() {
    super.initState();

    _pages = const [
      OrdersPage(key: PageStorageKey('orders')),
      ProductsPage(key: PageStorageKey('products')),
      ReviewsPage(key: PageStorageKey('reviews')),
      VideosPage(key: PageStorageKey('videos')),
      ContentAdminPage(key: PageStorageKey('content-admin')),
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!mounted || _disposed) return;
    setState(fn);
  }

  // ================== Sidebar Content ==================

  Widget _buildSidebarContent() {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff111827), Color(0xff1f2937)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            SizedBox(
              height: 90,
              child: Lottie.network(
                "https://assets5.lottiefiles.com/packages/lf20_zrqthn6o.json",
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "لوحة التحكم",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "ButterFly Admin",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.white.withOpacity(0.25)),
            ),

            const SizedBox(height: 8),

            // عناصر الناف في Scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    _navItem(0, Icons.receipt_long, "الطلبات"),
                    const SizedBox(height: 6),
                    _navItem(1, Icons.shopping_bag_outlined, "المنتجات"),
                    const SizedBox(height: 6),
                    _navItem(2, Icons.rate_review, "التقييمات"),
                    const SizedBox(height: 6),
                    _navItem(3, Icons.video_library, "الفيديوهات"),
                    const SizedBox(height: 6),
                    _navItem(4, Icons.description_outlined, "محتوى الصفحات"),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.white.withOpacity(0.2)),
            ),

            // معلومات بسيطة + زر تسجيل خروج (اختياري)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "v1.0.0",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                  IconButton(
                    tooltip: "تسجيل الخروج",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // سايدبار ثابت للشاشات الكبيرة
  Widget _buildSidebar() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: _buildSidebarContent(),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _selected == index;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        _safeSetState(() {
          _selected = index;
        });

        if (!_disposed) {
          _controller
            ..reset()
            ..forward();
        }
        final scaffoldState = Scaffold.maybeOf(context);
        if (scaffoldState?.isEndDrawerOpen ?? false) {
          Navigator.of(context).pop();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: Colors.amber.withOpacity(0.8), width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: isSelected ? Colors.amber : Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ================== Build ==================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: Colors.grey[50],

          endDrawer: isWide ? null : Drawer(child: _buildSidebarContent()),

          body: Row(
            children: [
              if (isWide) _buildSidebar(),

              Expanded(
                child: Column(
                  children: [
                    // توب بار
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isWide)
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                );
                              },
                            ),
                          Text(
                            _titles[_selected],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 58, 64, 183),
                            child: Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // محتوى الصفحة مع Fade
                    Expanded(
                      child: FadeTransition(
                        opacity: _fade,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _pages[_selected],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
