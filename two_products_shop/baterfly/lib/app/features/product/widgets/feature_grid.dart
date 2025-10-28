import 'package:flutter/material.dart';

class FeatureGrid extends StatefulWidget {
  final List<String> items;
  const FeatureGrid(this.items);

  @override
  State<FeatureGrid> createState() => _FeatureGridState();
}

class _FeatureGridState extends State<FeatureGrid> {
  int _hover = -1;

  @override
  Widget build(BuildContext context) {
    final twoCols = MediaQuery.sizeOf(context).width > 520;
    final cross = twoCols ? 2 : 1;
    return GridView.builder(
      itemCount: widget.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cross,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 5,
      ),
      itemBuilder: (_, i) {
        final hovered = _hover == i;
        return MouseRegion(
          onEnter: (_) => setState(() => _hover = i),
          onExit: (_) => setState(() => _hover = -1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: hovered
                  ? const Color(0x1A22D1FF)
                  : const Color(0x0F22D1FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hovered
                    ? const Color(0x5522D1FF)
                    : const Color(0x2222D1FF),
              ),
              boxShadow: hovered
                  ? const [
                      BoxShadow(
                        color: Color(0x221ED4FF),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 18,
                  color: Color(0xFF22D1FF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      widget.items[i],
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.5,
                        fontSize: 14.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
