import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/task_model.dart';
import '../../../core/routes/app_routes.dart';
import '../../controllers/task_controller.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const TaskCard({Key? key, required this.task, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onToggle,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: task.isCompleted ? Colors.green : Colors.grey[300],
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : const Icon(Icons.circle, size: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/images/${_getCategoryIcon(task.category)}',
              width: 20,
              color: _getCategoryColor(task.category),
            ),
          ],
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: task.dueDate != null
            ? Text(
          '${task.priority} • ${_formatDate(task.dueDate!)}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        )
            : null,
        trailing: const Icon(Icons.access_time, color: Colors.grey),
        onTap: () => Get.toNamed(Routes.EDIT_TASK, arguments: task)?.then((_) => Get.find<TaskController>().loadTasks()),
      ),
    );
  }

  String _getCategoryIcon(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.work: return 'work.svg';
      case TaskCategory.personal: return 'personal.svg';
      case TaskCategory.health: return 'health.svg';
      case TaskCategory.study: return 'study.svg';
    }
  }

  Color _getCategoryColor(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.work: return Colors.blue;
      case TaskCategory.personal: return Colors.purple;
      case TaskCategory.health: return Colors.green;
      case TaskCategory.study: return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDay = DateTime(date.year, date.month, date.day);

    if (taskDay == today) return 'Today ${DateFormat('hh:mm a').format(date)}';
    if (taskDay == today.add(const Duration(days: 1))) return 'Tomorrow ${DateFormat('hh:mm a').format(date)}';
    return DateFormat('MMM dd, hh:mm a').format(date);
  }
}