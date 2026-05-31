import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Todo>> getTodos() async {
    return await localDataSource.getLastTodos();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final currentTodos = await localDataSource.getLastTodos();

    final todoModel = TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      createdAt: todo.createdAt,
      image: todo.image,
      status: todo.status,
    );

    currentTodos.add(todoModel);
    await localDataSource.cacheTodos(currentTodos);
  }

  @override
  Future<void> updateTodo(Todo updatedTodo) async {
    final currentTodos = await localDataSource.getLastTodos();
    final index = currentTodos.indexWhere((todo) => todo.id == updatedTodo.id);

    if (index != -1) {
      currentTodos[index] = TodoModel(
        id: updatedTodo.id,
        title: updatedTodo.title,
        description: updatedTodo.description,
        createdAt: updatedTodo.createdAt,
        image: updatedTodo.image,
        status: updatedTodo.status,
      );
      await localDataSource.cacheTodos(currentTodos);
    }
  }

  @override
  Future<void> removeTodo(String id) async {
    final currentTodos = await localDataSource.getLastTodos();
    currentTodos.removeWhere((todo) => todo.id == id);
    await localDataSource.cacheTodos(currentTodos);
  }
}