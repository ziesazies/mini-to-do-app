import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Form(
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Title is required '
                              : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    _selectedDeadline != null
                        ? 'Deadline: ${_selectedDeadline!.toLocal()}'.split(
                          ' ',
                        )[0]
                        : 'Select Deadline (optional)',
                  ),
                  trailing: const Icon(Icons.calendar_today),
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
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  items:
                      ['General', 'Work', 'Personal']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newTodo = Todo(
                        id: Random().nextInt(99999).toString(),
                        title: _titleController.text,
                        description:
                            _descriptionController.text.isEmpty
                                ? null
                                : _descriptionController.text,
                        deadline: _selectedDeadline,
                        category: _selectedCategory,
                      );
                      context.read<TodoBloc>().add(AddTodo(newTodo));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Todo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
