import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/domain/entities/todo.dart';
import 'package:todo_flutter/domain/usecases/sorting_todo.dart';

void main() {
  late SortingTodo usecase;
  late List<Todo> mockTodos;

  setUp(() {
    usecase = SortingTodo();
    mockTodos = [
      Todo(id: '1', title: 'Zebra', description: '', status: TodoStatus.COMPLETED, createdAt: DateTime(2026, 5, 1)), // เก่าสุด, ตัว Z, เสร็จแล้ว
      Todo(id: '2', title: 'Apple', description: '', status: TodoStatus.IN_PROGRESS, createdAt: DateTime(2026, 5, 3)), // ใหม่สุด, ตัว A, กำลังทำ
      Todo(id: '3', title: 'Mango', description: '', status: TodoStatus.IN_PROGRESS, createdAt: DateTime(2026, 5, 2)), // กลางๆ, ตัว M, กำลังทำ
    ];
  });

  group('SortingTodo UseCase', () {
    test('SortBy.title - Should sort by title in ascending order', () {
      final result = usecase.call(mockTodos, SortBy.title);
      
      expect(result[0].title, 'Apple');
      expect(result[1].title, 'Mango');
      expect(result[2].title, 'Zebra');
    });

    test('SortBy.date - Should sort by date in descending order', () {
      final result = usecase.call(mockTodos, SortBy.date);
      
      expect(result[0].createdAt, DateTime(2026, 5, 3));
      expect(result[1].createdAt, DateTime(2026, 5, 2));
      expect(result[2].createdAt, DateTime(2026, 5, 1));
    });

    test('SortBy.status - Should put IN_PROGRESS before COMPLETED', () {
      final result = usecase.call(mockTodos, SortBy.status);
      
      expect(result[0].status, TodoStatus.IN_PROGRESS);
      expect(result[1].status, TodoStatus.IN_PROGRESS);
      
      expect(result[2].status, TodoStatus.COMPLETED);
    });
  });
}