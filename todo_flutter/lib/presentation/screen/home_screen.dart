import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_flutter/core/constants/image_resource.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_list_provider.dart';
import '../widgets/todo_form.dart';
import '../../domain/usecases/sorting_todo.dart';
import '../providers/filtered_todos_provider.dart';
import '../providers/searching_provider.dart';
import '../providers/sort_by_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTodosState = ref.watch(filteredTodosProvider);
    final currentSortMode = ref.watch(sortByProvider);

    return Scaffold(
      appBar: AppBar(
        title: Container(child: Row(children: [SvgPicture.asset(ImageResource.edit), const SizedBox(width: 8), const Text('To-do List')])),
        actions: [
          PopupMenuButton<SortBy>(
            initialValue: currentSortMode,
            onSelected: (SortBy value) => ref.read(sortByProvider.notifier).updateSortBy(value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              const PopupMenuItem<SortBy>(
                value: SortBy.date,
                child: Row(children: [Icon(Icons.calendar_today), SizedBox(width: 8), Text('Sort by Date')]),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.title,
                child: Row(children: [Icon(Icons.text_fields), SizedBox(width: 8), Text('Sort by Title')]),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.status,
                child: Row(children: [Icon(Icons.check_circle), SizedBox(width: 8), Text('Sort by Status')]),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'What\'s task you looking for?',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                filled: true,
                fillColor: Colors.grey.shade100,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    ImageResource.searchNormal,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn), // คุมสีไอคอนให้เป็นสีเทา
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(48),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => ref.read(searchingProvider.notifier).updateSearchQuery(value),
            ),
          ),
          Expanded(
            child: filteredTodosState.when(
              data: (todos) {
                if (todos.isEmpty) return const Center(child: Text('No tasks found.'));
                
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Dismissible(
                      key: Key(todo.id),
                      background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                      onDismissed: (direction) {
                        ref.read(todoListProvider.notifier).removeTodo(todo.id);
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.status == TodoStatus.COMPLETED,
                          onChanged: (bool? value) {
                            final updatedTodo = Todo(
                              id: todo.id,
                              title: todo.title,
                              description: todo.description,
                              createdAt: todo.createdAt,
                              image: todo.image,
                              status: value == true ? TodoStatus.COMPLETED : TodoStatus.IN_PROGRESS,
                            );
                            ref.read(todoListProvider.notifier).updateExistingTodo(updatedTodo);
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(decoration: todo.status == TodoStatus.COMPLETED ? TextDecoration.lineThrough : null),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (todo.description.isNotEmpty) Text(todo.description),
                            Text(
                              '${todo.createdAt.day}/${todo.createdAt.month}/${todo.createdAt.year}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        
                        trailing: todo.image != null 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.memory(
                                base64Decode(todo.image!),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : null,
                          
                        onTap: () => TodoForm.show(context, todo: todo),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TodoForm.show(context),
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
        foregroundColor: Colors.red,
        backgroundColor: Colors.white,
      ),
    );
  }
}