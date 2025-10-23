import 'package:flutter/material.dart';

class FsNode {
  final String name;
  final bool isDir;
  final List<FsNode> children;
  const FsNode(this.name, {this.isDir = true, this.children = const []});
}

class FolderTree extends StatelessWidget {
  final FsNode root;
  const FolderTree({super.key, required this.root});

  @override
  Widget build(BuildContext context) => _Dir(node: root, depth: 0);
}

class _Dir extends StatefulWidget {
  final FsNode node;
  final int depth;
  const _Dir({required this.node, required this.depth});

  @override
  State<_Dir> createState() => _DirState();
}

class _DirState extends State<_Dir> {
  bool open = true;

  @override
  Widget build(BuildContext context) {
    final n = widget.node;
    final hasKids = n.children.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: n.isDir && hasKids ? () => setState(() => open = !open) : null,
          child: Row(
            children: [
              SizedBox(width: widget.depth * 16),
              if (n.isDir && hasKids)
                AnimatedRotation(
                  turns: open ? 0.25 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(Icons.chevron_right, size: 18),
                )
              else
                const SizedBox(width: 18),
              const SizedBox(width: 6),
              Icon(
                n.isDir ? Icons.folder : Icons.insert_drive_file,
                size: 18,
                color: n.isDir ? Colors.amber[700] : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  n.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: n.isDir ? FontWeight.w600 : FontWeight.w400,
                    color: n.isDir ? Colors.black87 : Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: open
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              children: n.children
                  .map((c) => _Dir(node: c, depth: widget.depth + 1))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
