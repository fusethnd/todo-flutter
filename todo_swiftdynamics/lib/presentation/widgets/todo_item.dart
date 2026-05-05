import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final String title;
  final String? description;
  final bool completed;
  final VoidCallback? onTap;

  const TodoItem({
    Key? key,
    required this.title,
    this.description,
    this.completed = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(
        value: completed,
        onChanged: (_) => onTap?.call(),
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: completed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: description != null ? Text(description!) : null,
    );
  }
}