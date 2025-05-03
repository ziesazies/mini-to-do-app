import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_state.dart';
import 'package:mini_to_do_app/presentation/pages/add_todo_page.dart';
import 'package:mini_to_do_app/presentation/pages/todo_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('is_logged_in', false);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            final todos = [...state.todos];
            todos.sort((a, b) {
              if (a.isDone && !b.isDone) return 1;
              if (!a.isDone && b.isDone) return -1;
              return 0;
            });
            return ImplicitlyAnimatedList<Todo>(
              areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
              items: todos,
              itemBuilder: (context, animation, todo, index) {
                return SizeFadeTransition(
                  animation: animation,
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(todo.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: todo.isDone,
                          onChanged: (value) {
                            final updatedTodo = todo.copyWith(isDone: value);
                            context.read<TodoBloc>().add(EditTodo(updatedTodo));
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TodoDetailPage(todoId: todo.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final newTodo = Todo(
          //   id: Random().nextInt(999999).toString(),
          //   title: 'New Todo',
          //   description: 'Test',
          //   category: 'Work',
          // );
          // context.read<TodoBloc>().add(AddTodo(newTodo));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTodoPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
