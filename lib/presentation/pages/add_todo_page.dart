import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';

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
                    _onSubmit();
                  },
                  child: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
