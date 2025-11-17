import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../data/local/database/app_database.dart';
import '../../domain/repositories/task_repository.dart';
import '../controllers/task_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppDatabase>(() => AppDatabase.instance, fenix: true);

    // This now works without any error!
    Get.lazyPut<TaskRepository>(() => TaskRepositoryImpl(), fenix: true);

    Get.lazyPut<TaskController>(
          () => TaskController(Get.find<TaskRepository>()),
      fenix: true,
    );
  }
}