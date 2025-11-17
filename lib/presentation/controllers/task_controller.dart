import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../domain/repositories/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository taskRepository;

  // Constructor injection – GetX will provide the repository automatically
  TaskController(this.taskRepository);

  // Observable list of tasks
  var tasks = <Task>[].obs;

  // Currently selected category filter (null = All)
  var selectedCategory = Rxn<TaskCategory>();

  // Loading state
  var isLoading = true.obs;

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  /// Load tasks from repository (with optional category filter)
  Future<void> loadTasks() async {
    try {
      isLoading(true);
      final result = await taskRepository.getTasks(category: selectedCategory.value);
      tasks.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks', backgroundColor: Colors.red[100]);
    } finally {
      isLoading(false);
    }
  }

  /// Filter tasks by category
  void filterByCategory(TaskCategory? category) {
    selectedCategory.value = category;
    loadTasks();
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    await taskRepository.addTask(task);
    await loadTasks();
    Get.snackbar('Success', 'Task added!', backgroundColor: Colors.green[100]);
  }

  /// Toggle task completion status
  Future<void> toggleTask(Task task) async {
    await taskRepository.toggleTask(task);
    await loadTasks();
  }

  /// Update existing task
  Future<void> updateTask(Task task) async {
    await taskRepository.updateTask(task);
    await loadTasks();
    Get.snackbar('Updated', 'Task saved!', backgroundColor: Colors.blue[100]);
  }

  /// Delete a task by ID
  Future<void> deleteTask(int id) async {
    await taskRepository.deleteTask(id); // ← Use repository instead of direct DB call
    await loadTasks();
    Get.snackbar('Deleted', 'Task removed', backgroundColor: Colors.red[100]);
  }

  /// Optional: Get total completed tasks
  int get completedCount => tasks.where((t) => t.isCompleted).length;

  /// Optional: Get pending tasks count
  int get pendingCount => tasks.where((t) => !t.isCompleted).length;
}