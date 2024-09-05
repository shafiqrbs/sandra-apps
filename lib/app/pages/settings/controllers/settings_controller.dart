import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';

enum Buttons {
  purchase,
}

class SettingsController extends BaseController {
  final buttons = Rx<Buttons?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void changeButton(Buttons button) {
    if (buttons.value == button) {
      buttons.value = null;
      return;
    }
    buttons.value = button;
  }
}
