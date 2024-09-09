import 'package:get/get.dart';
import '/app/pages/content/account_config/controllers/account_config_controller.dart';

class AccountConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountConfigController>(
      AccountConfigController.new,
      fenix: true,
    );
  }
}
