// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'order/orders_page.dart';
import 'reviews/reviews_page.dart';

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

  final _titles = ['الطلبات', 'التقييمات'];

  @override
  void initState() {
    super.initState();

    _pages = const [
      OrdersPage(key: PageStorageKey('orders')),
      ReviewsPage(key: PageStorageKey('reviews')),
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

  Widget _buildSidebar() {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),

          Lottie.network(
            "https://assets5.lottiefiles.com/packages/lf20_zrqthn6o.json",
            height: 120,
          ),

          const SizedBox(height: 12),
          const Text(
            "Admin Panel",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Divider(color: Colors.white38),
          ),

          _navItem(0, Icons.receipt_long, "الطلبات"),
          _navItem(1, Icons.rate_review, "التقييمات"),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _selected == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.amber : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.amber : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        _safeSetState(() {
          _selected = index;
        });

        if (!_disposed) {
          _controller
            ..reset()
            ..forward();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
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
  }
}
