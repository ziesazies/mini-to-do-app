import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/data/datasources/todo_local_storage.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/todo/todo_event.dart';
import 'package:mini_to_do_app/presentation/pages/login_page.dart';
import 'package:mini_to_do_app/presentation/pages/todo_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = TodoLocalStorage();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn, storage: storage));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final TodoLocalStorage storage;
  const MyApp({super.key, required this.isLoggedIn, required this.storage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc(storage)..add(LoadTodos()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: isLoggedIn ? const TodoListPage() : const LoginPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/todoList': (_) => const TodoListPage(),
        },
      ),
    );
  }
}
