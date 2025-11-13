// pages/orders_page.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/orders_controller.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersController()..loadOrders(),
      child: Consumer<OrdersController>(
        builder: (context, ctrl, _) {
          if (ctrl.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = ctrl.filteredOrders;
          final counts = ctrl.statusCounts;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isTablet = constraints.maxWidth > 600 && !isWide;

              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      children: [
                        // الهيدر
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'إدارة الطلبات',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: 'تحديث',
                                onPressed: () => ctrl.loadOrders(),
                                icon: const Icon(Icons.refresh),
                              ),
                            ],
                          ),
                        ),

                        // كارت الإحصائيات
                        OrdersStatsCard(
                          totalOrders: ctrl.totalOrders,
                          counts: counts,
                          isWide: isWide,
                        ),

                        const SizedBox(height: 8),

                        // الفلتر
                        OrdersFilterBar(
                          currentStatus: ctrl.statusFilter,
                          onFilterChanged: ctrl.setFilter,
                        ),

                        const SizedBox(height: 8),

                        // قائمة الطلبات
                        Expanded(
                          child: OrdersList(
                            orders: orders,
                            isWide: isWide,
                            isTablet: isTablet,
                            onChangeStatus: (id, status) =>
                                ctrl.changeStatus(id, status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
