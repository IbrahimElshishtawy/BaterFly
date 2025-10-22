import 'package:flutter/material.dart';
import 'fade_slide.dart';

class StaggeredGrid extends StatelessWidget {
  final SliverGridDelegate gridDelegate;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Duration baseDelay;
  const StaggeredGrid({
    super.key,
    required this.gridDelegate,
    required this.itemCount,
    required this.itemBuilder,
    this.baseDelay = const Duration(milliseconds: 40),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: (ctx, i) =>
          FadeSlide(delay: baseDelay * i, child: itemBuilder(ctx, i)),
    );
  }
}
