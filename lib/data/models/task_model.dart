// lib/data/models/task_model.dart

enum TaskCategory { work, personal, health, study }

class Task {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final TaskCategory category;
  final String? priority; // Low, Medium, High

  const Task({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.category = TaskCategory.work,
    this.priority,
  });

  // Convert Task to Map for SQflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'dueDate': dueDate?.toIso8601String(),
      'category': category.index,
      'priority': priority,
    };
  }

  // Create Task from Map (from database)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: (map['isCompleted'] as int) == 1,
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'] as String)
          : null,
      category: TaskCategory.values[map['category'] as int? ?? 0],
      priority: map['priority'] as String?,
    );
  }

  // CopyWith method (immutable update)
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    TaskCategory? category,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }

  // Optional: for debugging / logging
  @override
  String toString() {
    return 'Task(id: $id, title: $title, completed: $isCompleted, category: $category, priority: $priority)';
  }

  // Optional: for future JSON API support
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      category: TaskCategory.values[json['category'] ?? 0],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() => toMap();
}