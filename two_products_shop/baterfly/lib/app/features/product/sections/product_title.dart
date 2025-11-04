// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:baterfly/app/data/static/product_data.dart';
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 800
            ? 800
            : constraints.maxWidth * 0.95; // حد أقصى للعرض على الويب

        return Center(
          child: Container(
            width: maxWidth,
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.0),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 32 : 20,
                    vertical: constraints.maxWidth > 600 ? 32 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  اسم المنتج
                      Text(
                        ProductData.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.8,
                              fontSize: constraints.maxWidth > 800 ? 30 : 22,
                            ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        ProductData.type,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.pinkAccent.shade100,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              fontSize: constraints.maxWidth > 800 ? 20 : 16,
                            ),
                      ),

                      const SizedBox(height: 14),

                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        ProductData.description,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.7,
                          fontSize: constraints.maxWidth > 800 ? 17 : 15,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.pinkAccent.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "🦋 ${ProductData.marketingPhrases.first}",
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.pinkAccent.shade100,
                                fontWeight: FontWeight.w600,
                                fontSize: constraints.maxWidth > 800
                                    ? 16
                                    : 14.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
