import 'package:get/get.dart';
import '/app/pages/accounting/customer_ledger/controllers/customer_ledger_controller.dart';

class CustomerLedgerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerLedgerController>(
      CustomerLedgerController.new,
      fenix: true,
    );
  }
}
  