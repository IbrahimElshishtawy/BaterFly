// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

class UsageAccordion extends StatefulWidget {
  final List<String> steps;

  const UsageAccordion({super.key, required this.steps});

  @override
  State<UsageAccordion> createState() => _UsageAccordionState();
}

class _UsageAccordionState extends State<UsageAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                onExpansionChanged: (expanded) {
                  setState(() => _isExpanded = expanded);
                },
                trailing: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _isExpanded ? 0.5 : 0,
                  child: const Icon(Icons.expand_more, color: Colors.white),
                ),
                title: Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.pinkAccent,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "📋 طريقة الاستخدام",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                children: widget.steps
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "• ",
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontSize: 18,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                s,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
