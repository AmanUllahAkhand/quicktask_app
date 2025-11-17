import 'package:get/get.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../../data/local/database/app_database.dart';
import '../controllers/task_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController(TaskRepositoryImpl(AppDatabase.instance)));
  }
}