import 'package:get/get.dart';
import '/app/pages/expense_list/controllers/expense_list_controller.dart';

class ExpenseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseListController>(
      () => ExpenseListController(),
      fenix: true,
    );
  }
}
  