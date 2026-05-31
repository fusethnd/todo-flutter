import '../entities/todo.dart';

enum SortBy {date, title, status}

class SortingTodo {
  List<Todo> call(List<Todo> todos, SortBy sortBy) {
    final sortedList = List<Todo>.from(todos);
    
    switch (sortBy) {
      case SortBy.title:
        sortedList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortBy.date:
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortBy.status:
        sortedList.sort((a, b) {
          final aStatus = a.status == TodoStatus.IN_PROGRESS ? 0 : 1;
          final bStatus = b.status == TodoStatus.IN_PROGRESS ? 0 : 1;
          return aStatus.compareTo(bStatus);
      });
      break;
    }
    return sortedList;
  }
}