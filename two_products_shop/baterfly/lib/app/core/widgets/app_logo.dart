import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.spa,
          color: Theme.of(context).colorScheme.primary,
          size: size,
        ),
        const SizedBox(width: 8),
        Text(
          "لمسة حرير",
          style: TextStyle(
            fontSize: size * 0.45,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
