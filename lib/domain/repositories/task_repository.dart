import 'package:get/get.dart';
import '../../data/local/database/app_database.dart';
import '../../data/models/task_model.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({TaskCategory? category});
  Future<Task> addTask(Task task);
  Future<void> toggleTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int id);
}

class TaskRepositoryImpl implements TaskRepository {
  // Use Get.find() instead of direct instance → works perfectly with GetX DI
  final AppDatabase db = Get.find<AppDatabase>();

  TaskRepositoryImpl(); // ← Empty constructor (required for GetX)

  @override
  Future<List<Task>> getTasks({TaskCategory? category}) async {
    final maps = category == null
        ? await db.query('tasks', orderBy: 'id DESC')
        : await db.query(
      'tasks',
      where: 'category = ?',
      whereArgs: [category.index],
      orderBy: 'id DESC',
    );

    return maps.map((m) => Task.fromMap(m)).toList();
  }

  @override
  Future<Task> addTask(Task task) async {
    return await db.createTask(task);
  }

  @override
  Future<void> toggleTask(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await db.updateTask(updated);
  }

  @override
  Future<void> updateTask(Task task) async {
    await db.updateTask(task);
  }

  @override
  Future<void> deleteTask(int id) async {
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}