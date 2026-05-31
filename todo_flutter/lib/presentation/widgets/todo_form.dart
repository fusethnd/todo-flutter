import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../core/image_converter.dart';
import '../../domain/entities/todo.dart';
import '../providers/todo_list_provider.dart';

class TodoForm extends ConsumerStatefulWidget {
  final Todo? existingTodo;

  const TodoForm({super.key, this.existingTodo});

  static void show(BuildContext context, {Todo? todo}) {
    final isLargeScreen = MediaQuery.of(context).size.shortestSide > 600;

    if (isLargeScreen) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SizedBox(
            width: 400,
            child: TodoForm(existingTodo: todo),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => TodoForm(existingTodo: todo),
      );
    }
  }

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  
  // 🌟 1. ตัวแปรเก็บรูปภาพ (เก็บเป็น Base64 String)
  String? _imageBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingTodo?.title ?? '');
    _descController = TextEditingController(text: widget.existingTodo?.description ?? '');
    
    // 🌟 ดึงรูปเก่ามาแสดง (ถ้ามี)
    _imageBase64 = widget.existingTodo?.image;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // 🌟 2. ฟังก์ชันเปิดแกลเลอรีและแปลงรูปเป็น Base64
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // ลดคุณภาพนิดหน่อยเพื่อไม่ให้ Base64 ยาวเกินไป
      );
      
      if (image != null) {
        final File file = File(image.path);
        // เรียกใช้ ImageConverter ที่คุณสร้างไว้
        final String base64String = await ImageConverter.toBase64(file);
        
        setState(() {
          _imageBase64 = base64String;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  // ฟังก์ชันสำหรับลบรูป
  void _removeImage() {
    setState(() {
      _imageBase64 = null;
    });
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    final description = _descController.text.trim();

    if (title.isNotEmpty) {
      final todo = Todo(
        id: widget.existingTodo?.id ?? const Uuid().v4(),
        title: title,
        description: description,
        createdAt: DateTime.now(), // ประทับเวลาใหม่เสมอ
        image: _imageBase64,       // 🌟 ส่งรูปที่แปลงแล้วไปให้ Model
        status: widget.existingTodo?.status ?? TodoStatus.IN_PROGRESS,
      );

      if (widget.existingTodo == null) {
        ref.read(todoListProvider.notifier).addNewTodo(todo);
      } else {
        ref.read(todoListProvider.notifier).updateExistingTodo(todo);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.existingTodo == null ? 'Create Task' : 'Edit Task',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            maxLength: 100,
            decoration: const InputDecoration(
              labelText: 'Title *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          
          // 🌟 3. ส่วน UI สำหรับแสดงและเลือกรูปภาพ
          if (_imageBase64 != null) ...[
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(_imageBase64!),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white, shadows: [Shadow(blurRadius: 2)]),
                  onPressed: _removeImage,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ] else ...[
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Add Image'),
            ),
            const SizedBox(height: 16),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _handleSave,
                child: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}