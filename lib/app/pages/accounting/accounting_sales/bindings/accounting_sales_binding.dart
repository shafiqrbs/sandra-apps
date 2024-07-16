import 'package:get/get.dart';
import '/app/pages/accounting/accounting_sales/controllers/accounting_sales_controller.dart';

class AccountingSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountingSalesController>(
      AccountingSalesController.new,
      fenix: true,
    );
  }
}
