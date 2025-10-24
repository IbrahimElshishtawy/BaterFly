// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String?> {
  CustomSearchDelegate({String initial = ''}) {
    query = initial;
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => _hint();
  @override
  Widget buildSuggestions(BuildContext context) => _hint();

  Widget _hint() => Center(child: Text('اكتب اسم المنتج ثم Enter: $query'));

  @override
  void showResults(BuildContext context) => close(context, query);
}
