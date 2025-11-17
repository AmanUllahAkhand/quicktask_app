import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../core/routes/app_routes.dart';
import '../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback? onTap;  // ← Make it optional

  const TaskCard({
    Key? key,
    required this.task,
    required this.onToggle,
    this.onTap,  // ← Now optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: onTap ?? () => Get.toNamed(Routes.EDIT_TASK, arguments: task),
        leading: GestureDetector(
          onTap: onToggle,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: task.isCompleted ? Colors.green : Colors.grey[300],
            child: task.isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 20),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: task.dueDate != null
            ? Text(
          '${task.priority ?? 'No priority'} • ${_formatDate(task.dueDate!)}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        )
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDay = DateTime(date.year, date.month, date.day);

    if (taskDay == today) return 'Today';
    if (taskDay == tomorrow) return 'Tomorrow';
    return DateFormat('MMM dd').format(date);
  }
}