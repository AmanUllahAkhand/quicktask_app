import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const TaskCard({required this.task, required this.onTap, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: GestureDetector(
          onTap: onToggle,
          child: CircleAvatar(
            backgroundColor: task.isCompleted ? Colors.green : Colors.grey[300],
            child: task.isCompleted
                ? Icon(Icons.check, color: Colors.white)
                : Icon(Icons.radio_button_unchecked, color: Colors.grey),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Icon(Icons.access_time, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}