import 'package:get/get.dart';
import '/app/pages/accounting/expense/expense_list/controllers/expense_list_controller.dart';

class ExpenseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseListController>(
      ExpenseListController.new,
      fenix: true,
    );
  }
}
  