import 'package:get/get.dart';
import '/app/pages/accounting/expense/controllers/expense_controller.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseController>(
      () => ExpenseController(),
      fenix: true,
    );
  }
}
  