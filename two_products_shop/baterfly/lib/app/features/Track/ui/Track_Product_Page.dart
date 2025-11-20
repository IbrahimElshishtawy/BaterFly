// ignore_for_file: deprecated_member_use, file_names

import 'package:baterfly/app/core/routing/app_routes.dart';
import 'package:baterfly/app/features/Track/widgets/track_order_card.dart';
import 'package:flutter/material.dart';

import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:baterfly/app/services/supabase/orders_public_service.dart';

class TrackProductPage extends StatefulWidget {
  const TrackProductPage({super.key});

  @override
  State<TrackProductPage> createState() => _TrackProductPageState();
}

class _TrackProductPageState extends State<TrackProductPage> {
  final _service = OrdersPublicService();
  final TextEditingController _nameController = TextEditingController();

  String _query = '';
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.value(<Map<String, dynamic>>[]);
  }

  void _runTrack() {
    setState(() {
      _future = _service.findOrdersByFullName(_query);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: const SiteAppBar(transparent: false, title: 'تتبع طلبك'),
      body: Stack(
        children: [
          const GradientBackground(),
          LayoutBuilder(
            builder: (_, constraints) {
              final w = constraints.maxWidth;
              final pad = Responsive.hpad(w);
              final maxW = Responsive.maxWidth(w);

              double side = (w - maxW) / 2;
              final minSide = pad.horizontal / 2;
              if (side < minSide) side = minSide;

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snapshot) {
                  final loading =
                      snapshot.connectionState == ConnectionState.waiting;
                  final orders = snapshot.data ?? [];

                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // العنوان + الوصف
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 20, side, 8),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تتبع طلبك بالاسم',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'اكتب اسمك الكامل كما أدخلته في الطلب لمعرفة حالة طلباتك.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 8, side, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'مثال: أحمد محمد علي',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(.6),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black.withOpacity(0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.25),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.25),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_search,
                                      color: Colors.white.withOpacity(.85),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.search,
                                  onChanged: (val) {
                                    _query = val.trim();
                                  },
                                  onSubmitted: (_) {
                                    _query = _nameController.text.trim();
                                    if (_query.isNotEmpty) _runTrack();
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _query = _nameController.text.trim();
                                  if (_query.isNotEmpty) _runTrack();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('تتبع'),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // تحميل
                      if (loading)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        )
                      // لا يوجد نتائج
                      else if (!loading && _query.isNotEmpty && orders.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(side, 24, side, 16),
                            child: const Text(
                              'لا يوجد طلبات مطابقة لهذا الاسم حاليًا.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                      // لو فيه طلبات
                      if (orders.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(side, 8, side, 4),
                            child: Text(
                              'عدد الطلبات المطابقة: ${orders.length}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      if (orders.isNotEmpty)
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final o = orders[index];

                            return TrackOrderCard(
                              order: o,
                              sidePadding: side,
                              isLast: index == orders.length - 1,
                              onViewDetails: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.orderDetails,
                                  arguments: o['id'],
                                );
                              },
                            );
                          }, childCount: orders.length),
                        ),

                      const SliverToBoxAdapter(child: FooterLinks()),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
