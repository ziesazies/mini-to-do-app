import 'dart:convert';

import 'package:mini_to_do_app/domain/entities/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoLocalStorage {
  static const String _key = 'todos';

  Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Todo.fromJson(e)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(todos.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
