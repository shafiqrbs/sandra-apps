import 'package:get/get.dart';
import '/app/pages/accounting_purchase/controllers/accounting_purchase_controller.dart';

class AccountingPurchaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountingPurchaseController>(
      () => AccountingPurchaseController(),
      fenix: true,
    );
  }
}
  