import 'package:get/get.dart';
import '../../presentation/views/splash/splash_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/news/news_detail_screen.dart';
import '../di/binding.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => SplashScreen(), binding: SplashBinding()),
    GetPage(name: Routes.HOME, page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(name: Routes.NEWS_DETAIL, page: () => NewsDetailScreen(), transition: Transition.rightToLeft),
  ];
}