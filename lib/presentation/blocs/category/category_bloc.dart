import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_event.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  static const _key = 'categories';

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final stored =
          prefs.getStringList(_key) ?? ['General', 'Work', 'Personal'];
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
  }
}
