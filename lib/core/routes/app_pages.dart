import 'package:get/get.dart';

import '../../presentation/views/splash/splash_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/tasks/add_task_screen.dart';
import '../../presentation/views/news/news_feed_screen.dart';
import '../../presentation/views/news/news_detail_screen.dart';
import '../../presentation/bindings/splash_binding.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/news_binding.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    // Splash
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),

    // Home (Tasks) - Main Tab
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fade,
    ),

    // Add Task
    GetPage(
      name: Routes.ADD_TASK,
      page: () => AddTaskScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Edit Task
    // GetPage(
    //   name: Routes.EDIT_TASK,
    //   page: () => EditTaskScreen(),
    //   transition: Transition.downToUp,
    //   transitionDuration: const Duration(milliseconds: 300),
    // ),

    // News Feed
    GetPage(
      name: Routes.NEWS_FEED,
      page: () => NewsFeedScreen(),
      binding: NewsBinding(),
      transition: Transition.rightToLeft,
    ),

    // News Detail
    GetPage(
      name: Routes.NEWS_DETAIL,
      page: () => NewsDetailScreen(),
      transition: Transition.rightToLeft,
    ),

    // Profile
    // GetPage(
    //   name: Routes.PROFILE,
    //   page: () => ProfileScreen(),
    //   transition: Transition.fadeIn,
    // ),
  ];
}