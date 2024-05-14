import 'package:flutter/material.dart';
import 'package:hive_cruds/models/todo_model.dart';
import 'package:hive_cruds/screens/home_page.dart';
import 'package:hive_cruds/service/todo_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TodoAdapter());

  await TodoService().openBox();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
