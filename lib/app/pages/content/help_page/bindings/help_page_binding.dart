import 'package:get/get.dart';
import '/app/pages/content/help_page/controllers/help_page_controller.dart';

class HelpPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpPageController>(
      HelpPageController.new,
      fenix: true,
    );
  }
}
  