import 'package:mini_to_do_app/domain/entities/todo.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
}

class EditTodo extends TodoEvent {
  final Todo todo;
  EditTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
}
