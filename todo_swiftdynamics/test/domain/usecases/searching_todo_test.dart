import 'package:flutter_test/flutter_test.dart';
import 'package:todo_swiftdynamics/domain/entities/todo.dart';
import 'package:todo_swiftdynamics/domain/usecases/searching_todo.dart';

void main() {
  late SearchingTodo usecase;
  late List<Todo> mockTodos;

  setUp(() {
    usecase = SearchingTodo();
    mockTodos = [
      Todo(id: '1', title: 'Swift Dynamics', description: 'For Interview', createdAt: DateTime.now()),
      Todo(id: '2', title: 'To Do List', description: 'Testing Description', createdAt: DateTime.now()),
      Todo(id: '3', title: 'Fix Bug', description: 'UI issue in home screen', createdAt: DateTime.now()),
    ];
  });

  group('SearchingTodo UseCase', () {
    test('If search query is empty, should return the entire list', () {
      final result = usecase.call(mockTodos, '');
      expect(result.length, 3);
    });

    test('If search query contains only whitespace, should return the entire list', () {
      final result = usecase.call(mockTodos, '   ');
      expect(result.length, 3);
    });

    test('Should find items by title (case-insensitive)', () {
      final result = usecase.call(mockTodos, 'SWIFT'); 
      expect(result.length, 1);
      expect(result.first.title, 'Swift Dynamics');
    });

    test('Should find items by description', () {
      final result = usecase.call(mockTodos, 'testing'); 
      expect(result.length, 1);
      expect(result.first.title, 'To Do List');
    });

    test('If search query does not match any items, should return an empty list', () {
      final result = usecase.call(mockTodos, 'Bangkok');
      expect(result.isEmpty, true);
    });
  });
}