import 'package:flutter/material.dart';

class UsageAccordion extends StatefulWidget {
  final String? usage;
  const UsageAccordion({super.key, this.usage});

  @override
  State<UsageAccordion> createState() => _UsageAccordionState();
}

class _UsageAccordionState extends State<UsageAccordion> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (i, isOpen) {
        setState(() => expanded = !isOpen);
      },
      children: [
        ExpansionPanel(
          isExpanded: expanded,
          headerBuilder: (_, __) =>
              const ListTile(title: Text("Usage Instructions")),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(widget.usage ?? "No usage info provided."),
          ),
        ),
      ],
    );
  }
}
