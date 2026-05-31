import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/todo.dart';
import 'todo_list_provider.dart';
import 'searching_provider.dart';
import 'sort_by_provider.dart';
import 'usecase_providers.dart';

final filteredTodosProvider = Provider<AsyncValue<List<Todo>>>((ref) {
  final todoState = ref.watch(todoListProvider);
  final query = ref.watch(searchingProvider);
  final sortBy = ref.watch(sortByProvider);

  return todoState.whenData((todos) {
    final filtered = ref.read(searchingTodoUseCaseProvider).call(todos, query);
    final sorted = ref.read(sortingTodoUseCaseProvider).call(filtered, sortBy);
    return sorted;
  });
});