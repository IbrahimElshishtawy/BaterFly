import 'package:flutter/material.dart';

class LeftColumn extends StatelessWidget {
  final String imageUrl;
  final String shortDesc;

  const LeftColumn({
    super.key,
    required this.imageUrl,
    required this.shortDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          shortDesc,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
