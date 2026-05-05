import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo.dart';
import 'usecase_providers.dart';

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

final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);