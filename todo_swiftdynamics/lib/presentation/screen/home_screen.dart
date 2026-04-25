import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. รับฟังสถานะของ TodoList (Data, Loading, หรือ Error)
    final todoState = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My TODOs')),
      body: todoState.when(
        // กรณีมีข้อมูล (Data)
        data: (todos) => todos.isEmpty 
          ? const Center(child: Text('ยังไม่มีงานเลยยย'))
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Dismissible(
                  key: Key(todo.id),
                  background: Container(color: Colors.red, child: Icon(Icons.delete)),
                  onDismissed: (direction) {
                    ref.read(todoListProvider.notifier).removeTodo(todo.id);
                  },
                  child: ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Icon(
                    todo.status == TodoStatus.COMPLETED 
                      ? Icons.check_circle 
                      : Icons.radio_button_unchecked,
                    color: todo.status == TodoStatus.COMPLETED ? Colors.green : null,
                  ),
                  onTap: () {
                    // ทดสอบกดอัปเดตสถานะงาน
                    final updatedTodo = Todo(
                      id: todo.id,
                      title: todo.title,
                      description: todo.description,
                      createdAt: todo.createdAt,
                      image: todo.image,
                      status: todo.status == TodoStatus.COMPLETED 
                        ? TodoStatus.IN_PROGRESS 
                        : TodoStatus.COMPLETED,
                    );
                    ref.read(todoListProvider.notifier).updateExistingTodo(updatedTodo);
                  },
                ));
              },
            ),
        // กรณีรอโหลด (Loading)
        loading: () => const Center(child: CircularProgressIndicator()),
        // กรณีเกิดข้อผิดพลาด (Error)
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ทดสอบกดเพิ่มข้อมูลแบบ Simple
          final newTodo = Todo(
            id: const Uuid().v4(),
            title: 'งานใหม่ที่ ${DateTime.now().second}',
            description: 'สร้างขึ้นมาเพื่อทดสอบระบบ',
            createdAt: DateTime.now(),
            status: TodoStatus.IN_PROGRESS,
          );
          
          ref.read(todoListProvider.notifier).addNewTodo(newTodo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}