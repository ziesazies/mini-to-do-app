import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_state.dart';
import 'package:mini_to_do_app/presentation/pages/add_todo_page.dart';

class TodoDetailPage extends StatelessWidget {
  final String todoId;

  const TodoDetailPage({super.key, required this.todoId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TodoBloc>().state;

    if (state is! TodoLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final todoList = state.todos.where((t) => t.id == todoId).toList();
    if (todoList.isEmpty) {
      Future.microtask(
        () => Navigator.pushNamedAndRemoveUntil(
          context,
          "/todoList",
          (route) => false,
        ),
      );
      return const Scaffold(
        body: CircularProgressIndicator(),
        backgroundColor: Colors.white,
      );
    }

    final todo = todoList.first;

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog(context, todo);
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTodoPage(existingTodo: todo),
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.folder, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        todo.category,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Description Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todo.description?.isNotEmpty == true
                        ? todo.description!
                        : 'No description.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Status & Toggle
            Row(
              children: [
                Checkbox(
                  value: todo.isDone,
                  onChanged: (value) {
                    final updatedTodo = todo.copyWith(isDone: value);
                    context.read<TodoBloc>().add(EditTodo(updatedTodo));
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  todo.isDone ? "Completed" : "Mark as Done",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: todo.isDone ? Colors.green : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Todo"),
            content: const Text("Are you sure you want to delete this todo?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<TodoBloc>().add(DeleteTodo(todo.id));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${todo.title} deleted')),
                  );
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }
}
