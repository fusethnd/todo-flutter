import '../entities/todo.dart';

class SearchingTodo {
  List<Todo> call(List<Todo> todos, String query) {
    if (query.trim().isEmpty) return todos;
    
    final lowerQuery = query.toLowerCase();
    return todos
        .where((todo) => todo.title.toLowerCase().contains(lowerQuery) || todo.description.toLowerCase().contains(lowerQuery))
        .toList();
  }
}