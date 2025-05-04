import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_event.dart';
import 'package:mini_to_do_app/presentation/blocs/category/category_state.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_state.dart';

class AddTodoPage extends StatefulWidget {
  final Todo? existingTodo;

  const AddTodoPage({super.key, this.existingTodo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDeadline;
  String _selectedCategory = 'General';

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.existingTodo?.title ?? '';
    _descriptionController.text = widget.existingTodo?.description ?? '';
    _selectedDeadline = widget.existingTodo?.deadline;
    _selectedCategory = widget.existingTodo?.category ?? 'General';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.existingTodo != null;
      final newTodo = Todo(
        id:
            isEditing
                ? widget.existingTodo!.id
                : Random().nextInt(99999).toString(),
        title: _titleController.text,
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
        deadline: _selectedDeadline,
        category: _selectedCategory,
      );
      final event = isEditing ? EditTodo(newTodo) : AddTodo(newTodo);
      context.read<TodoBloc>().add(event);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTodo != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Todo' : 'Add Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Todo Title"),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        // hintText: "Masukkan todo title",
                        border: InputBorder.none,
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Title is required'
                                  : null,
                    ),
                  ],
                ),
              ),
              const Text("Todo Deadline (optional)"),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    _selectedDeadline != null
                        ? 'Deadline: ${DateFormat('yyyy-MM-dd').format(_selectedDeadline!)}'
                        : '',
                    style: TextStyle(
                      color:
                          _selectedDeadline != null
                              ? Colors.black
                              : Colors.grey,
                    ),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDeadline = picked;
                      });
                    }
                  },
                  trailing: const Icon(Icons.calendar_today),
                ),
              ),

              // const SizedBox(height: 16),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    final categories =
                        state.categories.toSet().union({'General'}).toList();
                    if (!categories.contains(_selectedCategory)) {
                      categories.add(_selectedCategory);
                    }
                    return Column(
                      children: [
                        Row(
                          children: [
                            const Text("Category"),
                            IconButton(
                              onPressed: () async {
                                final _newCategory =
                                    await _showAddCategoryDialog(
                                      context,
                                      false,
                                      null,
                                    );
                                if (_newCategory != null &&
                                    _newCategory.isNotEmpty) {
                                  if (_newCategory.toLowerCase() == 'general') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Cannot create category named 'General'.",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  context.read<CategoryBloc>().add(
                                    AddCategory(_newCategory),
                                  );
                                  setState(() {
                                    _selectedCategory = _newCategory;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "'$_newCategory' category has been added",
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () async {
                                final _toDelete = await _showAddCategoryDialog(
                                  context,
                                  true,
                                  categories,
                                );
                                if (_toDelete != null ||
                                    _toDelete == 'General') {
                                  if (_toDelete == 'General') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Cannot delete 'General' category.",
                                        ),
                                      ),
                                    );
                                  }
                                  final todoBloc = context.read<TodoBloc>();
                                  final currentTodos =
                                      (todoBloc.state is TodoLoaded)
                                          ? (todoBloc.state as TodoLoaded).todos
                                          : [];

                                  final matchingTodos =
                                      currentTodos
                                          .where(
                                            (todo) =>
                                                todo.category == _toDelete,
                                          )
                                          .toList();
                                  if (matchingTodos.isNotEmpty) {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text(
                                              "Delete Category",
                                            ),
                                            content: Text(
                                              "You have ${matchingTodos.length} todos in the '$_toDelete' category. "
                                              "Deleting this category will also delete these todos. Are you sure?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {},
                                                child: TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: Text("Cancel"),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: Text("Delete All"),
                                              ),
                                            ],
                                          ),
                                    );

                                    if (confirm != true) return;

                                    for (var todo in matchingTodos) {
                                      todoBloc.add(DeleteTodo(todo.id));
                                    }
                                  }

                                  context.read<CategoryBloc>().add(
                                    DeleteCategory(_toDelete ?? ''),
                                  );

                                  if (_selectedCategory == _toDelete) {
                                    setState(() {
                                      _selectedCategory = 'General';
                                    });
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "'$_toDelete' category has been deleted",
                                      ),
                                    ),
                                  );
                                }
                              },
                              // },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            items:
                                categories
                                    .map(
                                      (category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              Text("Description (optional)"),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showAddCategoryDialog(
    BuildContext context,
    bool isDelete,
    List<String>? categories,
  ) {
    final controller = TextEditingController();
    if (isDelete) {
      String? selected;
      final deletableCategories =
          categories?.where((c) => c != 'General').toList() ?? [];
      return showDialog<String>(
        context: context,
        builder: (context) {
          // final deletableCategories =
          //     categories?.where((c) => c != 'General').toList() ?? [];

          return AlertDialog(
            title: const Text("Delete Category"),
            content:
                deletableCategories.isNotEmpty
                    ? StatefulBuilder(
                      builder:
                          (context, setState) =>
                              DropdownButtonFormField<String>(
                                value: selected,
                                items:
                                    deletableCategories
                                        .map(
                                          (category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  selected = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Category",
                                ),
                              ),
                    )
                    : const Text("No deletable categories."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(deletableCategories.isNotEmpty ? "Cancel" : ""),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, selected),
                child: Text(deletableCategories.isNotEmpty ? "Delete" : "OK"),
              ),
            ],
          );
        },
      );
    } else {
      return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add New Category"),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: "Category Name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text("Create"),
              ),
            ],
          );
        },
      );
    }
  }
}
