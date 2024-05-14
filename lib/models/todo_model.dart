//title
//description
//created at
//completed

import 'package:hive_flutter/hive_flutter.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime createdAt;

  @HiveField(3)
  late bool completed;

  Todo(
      {required this.title,
      required this.description,
      required this.createdAt,
      required this.completed});
}
