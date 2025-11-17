import 'package:get/get.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? AppTheme.dark : AppTheme.light);
  }
}