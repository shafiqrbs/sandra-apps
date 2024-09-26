import 'package:get/get.dart';
import '/app/pages/theme_test_page/controllers/theme_test_page_controller.dart';

class ThemeTestPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeTestPageController>(
      () => ThemeTestPageController(),
      fenix: true,
    );
  }
}
