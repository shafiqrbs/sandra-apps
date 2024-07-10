import 'package:get/get.dart';
import '/app/pages/accounting/expense/create_expense/controllers/create_expense_controller.dart';

class CreateExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateExpenseController>(
      CreateExpenseController.new,
      fenix: true,
    );
  }
}
