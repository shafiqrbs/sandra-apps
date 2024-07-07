import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';

enum Buttons {
  purchase,
}

class SettingsController extends BaseController {
  final buttons = Rx<Buttons?>(null);

  final selectedPurchase = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    selectedPurchase.value = await prefs.getPurchaseConfig();
  }

  void changeButton(Buttons button) {
    if (buttons.value == button) {
      buttons.value = null;
      return;
    }
    buttons.value = button;
  }

  Future<void> changePurchase(String? config) async {
    if (config != null) {
      selectedPurchase.value = config;
      await prefs.setPurchaseConfig(config);
    }
  }
}
