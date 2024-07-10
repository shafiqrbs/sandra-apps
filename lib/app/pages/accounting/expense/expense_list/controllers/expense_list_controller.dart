import 'package:get/get.dart';
import 'package:getx_template/app/core/widget/dialog_pattern.dart';
import 'package:getx_template/app/global_modal/add_expense_modal/add_expense_view.dart';
import '/app/routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

class ExpenseListController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> showAddExpenseModal() async {
    final result = await Get.dialog(
      DialogPattern(
        title: 'add_expense'.tr,
        subTitle: 'add_expense'.tr,
        child: AddExpenseView(),
      ),
    );
  }
}
