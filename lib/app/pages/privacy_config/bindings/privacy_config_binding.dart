import 'package:get/get.dart';
import '/app/pages/privacy_config/controllers/privacy_config_controller.dart';

class PrivacyConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyConfigController>(
      () => PrivacyConfigController(),
      fenix: true,
    );
  }
}
  