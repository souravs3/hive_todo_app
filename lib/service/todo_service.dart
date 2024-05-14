import 'package:hive_cruds/models/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoService {
  Box<Todo>? _todobox;

  Future<void> openBox() async {
    _todobox = await Hive.openBox('todos');
  }

  Future<void> closeBox() async {
    await _todobox!.close();
  }

  //add todo.............

  Future<void> addTodo(Todo todo) async {
    if (_todobox == null) {
      await openBox();
    }
    await _todobox!.add(todo);
  }

  //get all todos.................

  Future<List<Todo>> getTodos() async {
    if (_todobox == null) {
      await openBox();
    }
    return _todobox!.values.toList();
  }

  //update todo.....................

  Future<void> updateTodo(int index, Todo todo) async {
    if (_todobox == null) {
      await openBox();
    }

    await _todobox!.putAt(index, todo);
  }

  //delete todo...................

  Future<void> deletetodo(int index) async {
    if (_todobox == null) {
      await openBox();
    }

    await _todobox!.deleteAt(index);
  }
}
