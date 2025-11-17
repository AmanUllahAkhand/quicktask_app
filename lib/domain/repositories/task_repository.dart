import '../../data/local/database/app_database.dart';
import '../../data/models/task_model.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask(Task task);
  Future<void> toggleTask(Task task);
}

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase db;
  TaskRepositoryImpl(this.db);

  @override
  Future<List<Task>> getTasks() => db.getTasks();

  @override
  Future<Task> addTask(Task task) => db.createTask(task);

  @override
  Future<void> toggleTask(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await db.updateTask(updated);
  }
}