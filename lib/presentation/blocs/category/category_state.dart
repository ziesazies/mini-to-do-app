abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<String> categories;
  CategoryLoaded(this.categories);
}
