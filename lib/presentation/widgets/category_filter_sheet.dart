import 'package:flutter/material.dart';

class CategoryFilterSheet extends StatelessWidget {
  final categories = ['All', 'Work', 'Personal', 'Urgent'];

  CategoryFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children:
          categories.map((category) {
            return ListTile(
              title: Text(category),
              onTap: () {
                Navigator.pop(context, category);
              },
            );
          }).toList(),
    );
  }
}
