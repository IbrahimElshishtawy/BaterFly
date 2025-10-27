// lib/app/features/admin/pages/orders_page.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../features/product/widgets/gradient_bg.dart';
import '../../../services/supabase/supabase_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  final _sb = Supa.client;
  late Future<List<Map<String, dynamic>>> f;
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  )..forward();

  @override
  void initState() {
    super.initState();
    f = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final res = await _sb
        .from('orders')
        .select()
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'قيد التنفيذ':
        return Colors.orangeAccent;
      case 'مكتمل':
        return Colors.green;
      case 'ملغي':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: f,
            builder: (context, s) {
              if (s.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final orders = s.data ?? const [];
              if (orders.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد طلبات حتى الآن',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: orders.length,
                itemBuilder: (_, i) {
                  final o = orders[i];
                  final name = o['full_name'] ?? '—';
                  final phone = o['phone1'] ?? '';
                  final status = o['status'] ?? 'غير محدد';
                  final total = o['total']?.toString() ?? '0';

                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _ac,
                      curve: Interval(
                        i / (orders.length + 1),
                        1,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white.withOpacity(0.95),
                        border: Border.all(color: Colors.black12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      phone,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _statusColor(
                                      status,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(status),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$total ج.م',
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
