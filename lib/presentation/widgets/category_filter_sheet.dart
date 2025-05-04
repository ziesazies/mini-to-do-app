import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_state.dart';

class CategoryFilterSheet extends StatelessWidget {
  const CategoryFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          final categories = ['All', ...state.categories];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView(
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
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
