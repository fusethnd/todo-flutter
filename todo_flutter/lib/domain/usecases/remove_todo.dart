import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class RemoveTodo {
  final TodoRepository repository;

  RemoveTodo(this.repository);

  Future<void> call(String id) async {
    await repository.removeTodo(id);
  }
}