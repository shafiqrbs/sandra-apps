import 'package:get/get.dart';
import '/app/pages/help_page/controllers/help_page_controller.dart';

class HelpPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpPageController>(
      () => HelpPageController(),
      fenix: true,
    );
  }
}
  