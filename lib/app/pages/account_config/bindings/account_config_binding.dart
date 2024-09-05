import 'package:get/get.dart';
import '/app/pages/account_config/controllers/account_config_controller.dart';

class AccountConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountConfigController>(
      () => AccountConfigController(),
      fenix: true,
    );
  }
}
  