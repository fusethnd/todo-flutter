import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/data/models/todo_model.dart';
import 'package:todo_flutter/domain/entities/todo.dart';

void main() {
  final tDate = DateTime.utc(2026, 5, 5);
  
  final tTodoModel = TodoModel(
    id: 'uuid-1234',
    title: 'Learn Unit Test',
    description: 'Write test for TodoModel',
    createdAt: tDate,
    image: 'base64_mock_string',
    status: TodoStatus.COMPLETED,
  );

  final tJson = {
    'id': 'uuid-1234',
    'title': 'Learn Unit Test',
    'description': 'Write test for TodoModel',
    'createdAt': tDate.toUtc().toIso8601String(),
    'image': 'base64_mock_string',
    'status': 'COMPLETED',
  };

  group('TodoModel', () {
    
    test('fromJson() should correctly convert JSON Map to TodoModel', () {
      final result = TodoModel.fromJson(tJson);

      expect(result.id, 'uuid-1234');
      expect(result.title, 'Learn Unit Test');
      expect(result.description, 'Write test for TodoModel');
      expect(result.image, 'base64_mock_string');
      expect(result.status, TodoStatus.COMPLETED);
      expect(result.createdAt.toUtc(), tDate.toUtc()); 
    });

    test('toJson() should correctly convert TodoModel to JSON Map', () {
      final result = tTodoModel.toJson();

      expect(result, tJson);
    });
    
  });
}