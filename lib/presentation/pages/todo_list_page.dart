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
import 'package:mini_to_do_app/presentation/widgets/category_filter_sheet.dart';
import 'package:mini_to_do_app/presentation/widgets/todo_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  String _currentCategory = "All";

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
        leading: IconButton(
          onPressed: () async {
            final selectedCategory = await showModalBottomSheet<String>(
              context: context,
              builder: (context) => CategoryFilterSheet(),
            );
            if (selectedCategory != null) {
              setState(() {
                _currentCategory = selectedCategory;
              });
              context.read<TodoBloc>().add(FilterByCategory(selectedCategory));
            }
          },
          icon: Icon(Icons.filter_list),
        ),
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

            // Show empty state if the filtered list is empty

            if (todos.isEmpty && _currentCategory != "All") {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.note_alt_outlined,

                      size: 80,

                      color: Colors.grey[400],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Category $_currentCategory is empty at this time.',

                      style: TextStyle(
                        fontSize: 16,

                        color: Colors.grey[600],

                        fontWeight: FontWeight.w500,
                      ),

                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Try creating new to-do.',

                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),

                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Show empty state if no todos exist at all

            if (todos.isEmpty && _currentCategory == "All") {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.note_alt_outlined,

                      size: 80,

                      color: Colors.grey[400],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'No to-dos available.',

                      style: TextStyle(
                        fontSize: 16,

                        color: Colors.grey[600],

                        fontWeight: FontWeight.w500,
                      ),

                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Create your first to-do!',

                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),

                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ImplicitlyAnimatedList<Todo>(
              areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
              items: todos,
              itemBuilder: (context, animation, todo, index) {
                return SizeFadeTransition(
                  animation: animation,
                  child: ToDoTile(
                    taskName: todo.title,
                    taskCategory: todo.category,
                    taskCompleted: todo.isDone,
                    onChanged: (p0) {
                      final updatedTodo = todo.copyWith(isDone: p0);
                      context.read<TodoBloc>().add(EditTodo(updatedTodo));
                    },
                    deleteFunction: (p0) {
                      context.read<TodoBloc>().add(DeleteTodo(todo.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${todo.title} deleted"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              context.read<TodoBloc>().add(AddTodo(todo));
                            },
                          ),
                        ),
                      );
                    },
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
