import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_event.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  static const _key = 'categories';
  static const _defaultCategories = ['General', 'Work', 'Personal'];

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList(_key) ?? _defaultCategories;

      if (!stored.contains('General')) {
        stored.insert(0, 'General');
        await prefs.setStringList(_key, stored);
      }

      emit(CategoryLoaded(stored));
    });

    on<AddCategory>((event, emit) async {
      if (state is CategoryLoaded) {
        final updated = List<String>.from((state as CategoryLoaded).categories);
        if (!updated.contains(event.category)) {
          updated.add(event.category);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setStringList(_key, updated);
          emit(CategoryLoaded(updated));
        }
      }
    });

    on<DeleteCategory>((event, emit) async {
      if (event.category == 'General') return; // prevent deleting General

      if (state is CategoryLoaded) {
        final updated = List<String>.from((state as CategoryLoaded).categories);
        updated.remove(event.category);

        // Ensure at least one category remains (General should always remain)
        if (updated.isEmpty || !updated.contains('General')) {
          updated.insert(0, 'General');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(_key, updated);
        emit(CategoryLoaded(updated));
      }
    });
  }
}
