import 'package:baterfly/app/core/widgets/dev/folder_tree_page.dart';
import 'package:flutter/material.dart';
import 'folder_tree_data.dart';

class FolderTreePage extends StatelessWidget {
  const FolderTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('هيكل المشروع')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
              children: [
                const Text(
                  'Project Structure',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Divider(),
                FolderTree(root: fsRoot),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
