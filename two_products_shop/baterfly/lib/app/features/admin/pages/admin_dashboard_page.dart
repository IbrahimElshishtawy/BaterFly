// lib/app/features/admin/pages/admin_dashboard_page.dart
// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/admin/pages/orders_page.dart';
import 'package:baterfly/app/features/admin/pages/reviews_page.dart';
import 'package:baterfly/app/features/admin/pages/settings_page.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  int _cols(double w) {
    if (w >= 1400) return 6;
    if (w >= 1200) return 5;
    if (w >= 992) return 4;
    if (w >= 720) return 3;
    if (w >= 520) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final items = <_AdminItem>[
      _AdminItem(
        title: 'الطلبات',
        icon: Icons.shopping_bag_outlined,
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrdersPage()),
        ),
      ),
      _AdminItem(
        title: 'التقييمات',
        icon: Icons.star_rate_rounded,
        color: Colors.amber.shade700,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReviewsPage()),
        ),
      ),
      _AdminItem(
        title: 'الإعدادات',
        icon: Icons.settings_rounded,
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        ),
      ),
    ];

    return Scaffold(
      appBar: const SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          LayoutBuilder(
            builder: (_, c) {
              final w = c.maxWidth;
              final pad = Responsive.hpad(w);
              final maxW = Responsive.maxWidth(w);
              final cols = _cols(w);

              double side = (w - maxW) / 2;
              final minSide = pad.horizontal / 2;
              if (side < minSide) side = minSide;

              return CustomScrollView(
                slivers: [
                  // شريط علوي بنفس ستايل الهوم
                  SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxW),
                        child: Padding(
                          padding: pad,
                          child: Container(
                            margin: const EdgeInsets.only(top: 14),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                colors: [Color(0x14FFFFFF), Color(0x0F000000)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(color: Color(0x22FFFFFF)),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.dashboard_customize_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'لوحة التحكم | نظرة عامة سريعة',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // الشبكة
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(side, 16, side, 24),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      delegate: SliverChildBuilderDelegate((context, i) {
                        final it = items[i];
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _ac,
                            curve: Interval(
                              i / (items.length + 1),
                              1,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                          child: _AdminTile(item: it),
                        );
                      }, childCount: items.length),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdminItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _AdminItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _AdminTile extends StatefulWidget {
  final _AdminItem item;
  const _AdminTile({required this.item});

  @override
  State<_AdminTile> createState() => _AdminTileState();
}

class _AdminTileState extends State<_AdminTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final radius = 16.0;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Theme.of(context).cardColor.withOpacity(0.96),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: _hover && kIsWeb
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ]
            : const [],
      ),
      child: InkWell(
        onTap: widget.item.onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة داخل شارة
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: widget.item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.item.color.withOpacity(0.35),
                  ),
                ),
                child: Icon(
                  widget.item.icon,
                  size: 28,
                  color: widget.item.color,
                ),
              ),
              const Spacer(),
              Text(
                widget.item.title,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'فتح الصفحة',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: _hover ? 1.015 : 1.0,
        child: card,
      ),
    );
  }
}
