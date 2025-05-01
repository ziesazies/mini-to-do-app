import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/data/datasources/todo_local_storage.dart';
import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoLocalStorage storage;

  TodoBloc(this.storage) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      print("🚀 LoadTodos triggered");
      final todos = await storage.getTodos();
      emit(TodoLoaded(todos));
    });

    on<AddTodo>((event, emit) async {
      if (state is TodoLoaded) {
        final updated = List<Todo>.from((state as TodoLoaded).todos)
          ..add(event.todo);
        await storage.saveTodos(updated);
        emit(TodoLoaded(updated));
      }
    });
    on<EditTodo>((event, emit) async {
      if (state is TodoLoaded) {
        final updated =
            (state as TodoLoaded).todos
                .map((e) => e.id == event.todo.id ? event.todo : e)
                .toList();
        await storage.saveTodos(updated);
        emit(TodoLoaded(updated));
      }
    });
    on<DeleteTodo>((event, emit) async {
      if (state is TodoLoaded) {
        final updated =
            (state as TodoLoaded).todos.where((e) => e.id != event.id).toList();
        await storage.saveTodos(updated);
        emit(TodoLoaded(updated));
      }
    });
  }
}
