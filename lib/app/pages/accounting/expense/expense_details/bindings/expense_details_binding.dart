import 'package:get/get.dart';
import '/app/pages/accounting/expense/expense_details/controllers/expense_details_controller.dart';

class ExpenseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseDetailsController>(
      ExpenseDetailsController.new,
      fenix: true,
    );
  }
}
  