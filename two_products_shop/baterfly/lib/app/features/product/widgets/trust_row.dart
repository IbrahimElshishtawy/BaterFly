import 'package:flutter/material.dart';

class TrustRow extends StatelessWidget {
  const TrustRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.verified, color: Colors.green),
          SizedBox(width: 8),
          Text(
            "منتج معتمد ومضمون من BUTTERFLY 💚",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
