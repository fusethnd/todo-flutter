import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getLastTodos();
  Future<void> cacheTodos(List<TodoModel> todosCache);
}

class TodoLocalDatasourceImpl implements TodoLocalDataSource {
  final String fileName = 'todos.json';

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  @override
  Future<List<TodoModel>> getLastTodos() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => TodoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todosCache) async {
    final file = await _localFile;
    final String jsonString = json.encode(todosCache.map((todo) => todo.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}