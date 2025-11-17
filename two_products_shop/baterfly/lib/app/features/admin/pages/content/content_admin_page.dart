// features/admin/content/content_admin_page.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'policy_editor.dart';
import 'support_editor.dart';

class ContentAdminPage extends StatelessWidget {
  const ContentAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ===== Header =====
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Colors.indigo,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'إدارة محتوى الصفحات الثابتة',
                        textDirection: TextDirection.rtl,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'يمكنك من هنا تعديل نصوص سياسة الشحن، وسياسة الاستبدال، وصفحة الدعم الفني دون الحاجة لتحديث التطبيق.',
                        textDirection: TextDirection.rtl,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // ===== Tabs =====
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const TabBar(
              isScrollable: true,
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.indigo,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'سياسة الشحن'),
                Tab(text: 'سياسة الاستبدال'),
                Tab(text: 'صفحة الدعم الفني'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Tab Views =====
          const Expanded(
            child: TabBarView(
              children: [
                PolicyEditor(slug: 'shipping', label: 'سياسة الشحن'),
                PolicyEditor(slug: 'returns', label: 'سياسة الاستبدال'),
                SupportEditor(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
