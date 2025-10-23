import 'package:flutter/material.dart';

class StaggeredGrid extends StatelessWidget {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  const StaggeredGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: .76,
      ),
      itemCount: itemCount,
      itemBuilder: (c, i) => TweenAnimationBuilder<double>(
        tween: Tween(begin: .8, end: 1),
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 220 + (i % 6) * 35),
        builder: (c, v, child) => Transform.scale(scale: v, child: child),
        child: itemBuilder(c, i),
      ),
    );
  }
}
