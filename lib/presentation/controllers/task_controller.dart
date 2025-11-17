import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../data/local/database/app_database.dart';

class TaskController extends GetxController {
  final TaskRepository taskRepository;

  TaskController(this.taskRepository);

  var tasks = <Task>[].obs;
  var selectedCategory = Rxn<TaskCategory>();
  var isLoading = true.obs;

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  Future<void> loadTasks() async {
    try {
      isLoading(true);
      final result = await taskRepository.getTasks(category: selectedCategory.value);
      tasks.assignAll(result);
    } finally {
      isLoading(false);
    }
  }

  void filterByCategory(TaskCategory? category) {
    selectedCategory.value = category;
    loadTasks();
  }

  Future<void> addTask(Task task) async {
    await taskRepository.addTask(task);
    await loadTasks();
  }

  Future<void> toggleTask(Task task) async {
    await taskRepository.toggleTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await taskRepository.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    final db = Get.find<AppDatabase>();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    await loadTasks();
  }
}