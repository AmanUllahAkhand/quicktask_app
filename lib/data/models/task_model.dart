// lib/data/models/task_model.dart
enum TaskCategory { work, personal, health, study }

class Task {
  int? id;
  String title;
  String? description;
  bool isCompleted;
  DateTime? dueDate;
  TaskCategory category;
  String? priority;

  Task({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.category = TaskCategory.work,
    this.priority,
  });

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

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      category: TaskCategory.values[map['category'] ?? 0],
      priority: map['priority'],
    );
  }

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
}