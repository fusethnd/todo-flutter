import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/todo_repository.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../data/datasources/todo_local_datasource.dart';
import '../../domain/usecases/get_todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/update_todo.dart';
import '../../domain/usecases/remove_todo.dart';
import '../../domain/usecases/searching_todo.dart';
import '../../domain/usecases/sorting_todo.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(localDataSource: TodoLocalDatasourceImpl());
});

final getTodosProvider = Provider((ref) => GetTodos(ref.watch(todoRepositoryProvider)));
final addTodoProvider = Provider((ref) => AddTodo(ref.watch(todoRepositoryProvider)));
final updateTodoProvider = Provider((ref) => UpdateTodo(ref.watch(todoRepositoryProvider)));
final removeTodoProvider = Provider((ref) => RemoveTodo(ref.watch(todoRepositoryProvider)));

final sortingTodoUseCaseProvider = Provider((ref) => SortingTodo());
final searchingTodoUseCaseProvider = Provider((ref) => SearchingTodo());