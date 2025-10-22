import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.local_mall,
          color: Theme.of(context).colorScheme.primary,
          size: size,
        ),
        const SizedBox(height: 8),
        const Text(
          'ButterFly Shop',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}
