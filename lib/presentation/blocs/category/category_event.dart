abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String category;
  AddCategory(this.category);
}

class UpdateCategory extends CategoryEvent {
  final String category;
  UpdateCategory(this.category);
}
