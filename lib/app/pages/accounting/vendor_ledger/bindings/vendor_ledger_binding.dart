import 'package:get/get.dart';
import '/app/pages/accounting/vendor_ledger/controllers/vendor_ledger_controller.dart';

class VendorLedgerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorLedgerController>(
      () => VendorLedgerController(),
      fenix: true,
    );
  }
}
  