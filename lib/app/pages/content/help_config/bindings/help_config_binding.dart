import 'package:get/get.dart';
import '/app/pages/content/help_config/controllers/help_config_controller.dart';

class HelpConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpConfigController>(
      HelpConfigController.new,
      fenix: true,
    );
  }
}
  