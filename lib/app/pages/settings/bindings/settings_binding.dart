import 'package:get/get.dart';
import '/app/pages/settings/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
      fenix: true,
    );
  }
}
