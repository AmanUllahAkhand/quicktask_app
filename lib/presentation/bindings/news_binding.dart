import 'package:get/get.dart';
import '../../../domain/repositories/news_repository.dart';
import '../../../data/remote/api/news_api_service.dart';
import '../controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewsApiService());
    Get.lazyPut(() => NewsRepositoryImpl(Get.find<NewsApiService>()));
    Get.lazyPut(() => NewsController(Get.find<NewsRepositoryImpl>()));
  }
}