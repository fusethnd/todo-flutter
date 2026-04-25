import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_swiftdynamics/domain/repositories/todo_repository.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/get_todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/update_todo.dart';
import '../../domain/usecases/remove_todo.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../data/datasources/todo_local_datasource.dart';

final todoReposityryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(localDataSource: TodoLocalDatasourceImpl());
});

final getTodosProvider = Provider((ref) => GetTodos(ref.watch(todoReposityryProvider)));
final addTodoProvider = Provider((ref) => AddTodo(ref.watch(todoReposityryProvider)));
final updateTodoProvider = Provider((ref) => UpdateTodo(ref.watch(todoReposityryProvider)));
final removeTodoProvider = Provider((ref) => RemoveTodo(ref.watch(todoReposityryProvider)));

class TodoListNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    return ref.watch(getTodosProvider).call();
  }

  Future<void> addNewTodo(Todo todo) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(addTodoProvider).call(todo);
      return await ref.read(getTodosProvider).call();
    });
  }

  Future<void> updateExistingTodo(Todo todo) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateTodoProvider).call(todo);
      return await ref.read(getTodosProvider).call();
    });
  }

  Future<void> removeTodo(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(removeTodoProvider).call(id);
      return await ref.read(getTodosProvider).call();
    });
  }
}

final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<Todo>>(() => TodoListNotifier());