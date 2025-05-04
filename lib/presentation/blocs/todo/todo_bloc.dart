import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/data/datasources/todo_local_storage.dart';
import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoLocalStorage storage;
  List<Todo> _allTodos = []; // Menyimpan semua todo untuk keperluan filter

  TodoBloc(this.storage) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      print("🚀 LoadTodos triggered");
      _allTodos = await storage.getTodos();
      emit(TodoLoaded(_allTodos));
    });

    on<AddTodo>((event, emit) async {
      if (state is TodoLoaded) {
        _allTodos.add(event.todo);
        await storage.saveTodos(_allTodos);
        emit(TodoLoaded(List.from(_allTodos)));
      }
    });

    on<EditTodo>((event, emit) async {
      if (state is TodoLoaded) {
        _allTodos =
            _allTodos
                .map((e) => e.id == event.todo.id ? event.todo : e)
                .toList();
        await storage.saveTodos(_allTodos);
        emit(TodoLoaded(List.from(_allTodos)));
      }
    });

    on<DeleteTodo>((event, emit) async {
      if (state is TodoLoaded) {
        _allTodos = _allTodos.where((e) => e.id != event.id).toList();
        await storage.saveTodos(_allTodos);
        emit(TodoLoaded(List.from(_allTodos)));
      }
    });
    on<FilterByCategory>((event, emit) async {
      if (event.category == "All") {
        emit(TodoLoaded(List.from(_allTodos)));
      } else {
        final filtered =
            _allTodos.where((todo) => todo.category == event.category).toList();
        emit(TodoLoaded(filtered));
      }
    });
  }
}
