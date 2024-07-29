import 'package:get/get.dart';
import 'package:sandra/app/core/base/base_controller.dart';

class PrefsSettingsModalController extends BaseController {
  final isSalesOnline = false.obs;
  final isZeroSalesAllowed = false.obs;
  final printerType = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isSalesOnline.value = await prefs.getIsSalesOnline();
    isZeroSalesAllowed.value = await prefs.getIsZeroSalesAllowed();
    printerType.value = await prefs.getPrintPaperType();
  }
}
