import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    super.image,
    required super.status,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      image: json['image'],
      status: json['status'] == 'COMPLETED' ? TodoStatus.COMPLETED : TodoStatus.IN_PROGRESS,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'image': image,
      'status': status == TodoStatus.COMPLETED ? 'COMPLETED' : 'IN_PROGRESS',
    };
  }
}