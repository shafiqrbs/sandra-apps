import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';

class PrefsSettingsModalController extends BaseController {
  final isSalesOnline = false.obs;
  final isPurchaseOnline = false.obs;
  final isZeroSalesAllowed = false.obs;
  final printerType = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isSalesOnline.value = await prefs.getIsSalesOnline();
    isPurchaseOnline.value = await prefs.getIsPurchaseOnline();
    isZeroSalesAllowed.value = await prefs.getIsZeroSalesAllowed();
    printerType.value = await prefs.getPrintPaperType();
  }
}
