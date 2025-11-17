import 'package:get/get.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/news_binding.dart';
import '../../presentation/bindings/splash_binding.dart';
import '../../presentation/views/splash/splash_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/news/news_detail_screen.dart';
import '../../presentation/views/tasks/add_task_screen.dart';
import '../di/binding.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => SplashScreen(), binding: SplashBinding()),
    GetPage(name: Routes.HOME, page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(name: Routes.NEWS_DETAIL, page: () => NewsDetailScreen(), transition: Transition.rightToLeft),
    // GetPage(name: '/add-task', page: () => AddTaskScreen()),
    GetPage(name: '/news-detail', page: () => NewsDetailScreen(), binding: NewsBinding()),
    GetPage(name: '/add-task', page: () => AddTaskScreen(), transition: Transition.downToUp,),
  ];
}