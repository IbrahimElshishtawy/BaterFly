// ignore_for_file: deprecated_member_use, file_names

import 'package:baterfly/app/features/Track/widgets/order_status_timeline.dart';
import 'package:flutter/material.dart';

import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';

import 'package:baterfly/app/services/supabase/orders_public_service.dart';
import 'package:baterfly/app/features/admin/pages/order/widgets/order_status_utils.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final _service = OrdersPublicService();
  late Future<Map<String, dynamic>?> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getOrderById(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: const SiteAppBar(transparent: false, title: 'تفاصيل الطلب'),
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

              return FutureBuilder<Map<String, dynamic>?>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'حدث خطأ أثناء تحميل تفاصيل الطلب.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final order = snapshot.data;
                  if (order == null) {
                    return const Center(
                      child: Text(
                        'لم يتم العثور على هذا الطلب.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  final status = (order['status'] ?? '').toString();
                  final statusClr = statusColor(status);

                  final orderNo =
                      order['order_no']?.toString() ?? order['id'].toString();
                  final fullName = order['full_name']?.toString() ?? 'بدون اسم';
                  final phone1 = order['phone1']?.toString() ?? '-';
                  final phone2 = order['phone2']?.toString() ?? '';
                  final city = order['city']?.toString() ?? '-';
                  final area = order['area']?.toString() ?? '-';
                  final address = order['address_text']?.toString() ?? '-';

                  final quantityStr = order['quantity']?.toString() ?? '1';
                  final quantity = num.tryParse(quantityStr) ?? 1;
                  final unit = (order['quantity_unit'] ?? 'unit').toString();

                  String unitLabel;
                  switch (unit) {
                    case 'gram':
                      unitLabel = 'جرام';
                      break;
                    case 'liter':
                      unitLabel = 'لتر';
                      break;
                    default:
                      unitLabel = 'وحدة';
                  }

                  final createdAt = order['created_at']?.toString() ?? '';

                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 20, side, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الطلب #$orderNo',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fullName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.85),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: statusClr.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  kStatusLabels[status] ?? '-',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: statusClr,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // المعلومات الأساسية
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 0, side, 16),
                          child: Card(
                            color: Colors.black.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'بيانات التواصل',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _infoRow('الهاتف 1', phone1),
                                  if (phone2.isNotEmpty)
                                    _infoRow('الهاتف 2', phone2),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'العنوان',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _infoRow('المدينة', city),
                                  _infoRow('المنطقة', area),
                                  _infoRow('وصف العنوان', address),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'التفاصيل الإضافية',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _infoRow(
                                    'الكمية المطلوبة',
                                    '$quantity $unitLabel',
                                  ),
                                  if (createdAt.isNotEmpty)
                                    _infoRow('تاريخ إنشاء الطلب', createdAt),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // الـ Timeline للحالة
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(side, 0, side, 24),
                          child: Card(
                            color: Colors.black.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.12),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: _OrderTimelineSection(),
                            ),
                          ),
                        ),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTimelineSection extends StatelessWidget {
  const _OrderTimelineSection();

  @override
  Widget build(BuildContext context) {
    return OrderStatusTimeline(
      currentStatus:
          (ModalRoute.of(context)?.settings.arguments as Map?)?['status'] ?? '',
    );
  }
}
