import 'package:baterfly/app/core/widgets/dev/folder_tree_page.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/dev/folder_tree_data.dart';

class FolderTreeUxPage extends StatelessWidget {
  const FolderTreeUxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UX • Project Folder Tree')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
              children: const [
                Text(
                  'Structure Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Divider(),
                FolderTree(root: fsRoot),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
