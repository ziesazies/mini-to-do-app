import 'package:flutter/material.dart';
import 'package:mini_to_do_app/presentation/pages/login_page.dart';
import 'package:mini_to_do_app/presentation/pages/todo_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLoggedIn ? TodoListPage() : LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/todoList': (context) => const TodoListPage(),
      },
    );
  }
}
