import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_state.dart';
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
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (_, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<TodoBloc>().add(DeleteTodo(todo.id));
                    },
                  ),
                  onTap: () {
                    final updated = todo.copyWith(isDone: !todo.isDone);
                    context.read<TodoBloc>().add(EditTodo(updated));
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newTodo = Todo(
            id: Random().nextInt(999999).toString(),
            title: 'New Todo',
            description: 'Test',
            category: 'Work',
          );
          context.read<TodoBloc>().add(AddTodo(newTodo));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
