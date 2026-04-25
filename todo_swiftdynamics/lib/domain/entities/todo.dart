enum TodoStatus { 
  IN_PROGRESS,
  COMPLETED, 
}

class Todo {
  final String id; // UUID
  final String title;
  final String description;
  final DateTime createdAt;
  final String? image; // Base64 encoded image string
  final TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.image,
    this.status = TodoStatus.IN_PROGRESS,
  });
}