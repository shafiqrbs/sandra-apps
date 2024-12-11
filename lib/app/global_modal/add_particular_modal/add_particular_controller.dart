import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import '/app/entity/transaction_methods.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/entity/expense_category.dart';
import '/app/entity/user.dart';
import '/app/routes/app_pages.dart';

class AddParticularController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final userManager = UserManager();
  final expenseCategoryManager = ExpenseCategoryManager();
  final transactionMethodsManager = TransactionMethodsManager();

  final amountController = TextEditingController().obs;
  final remarkController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    await expenseCategoryManager.fillAsController();
    await userManager.fillAsController();
    await transactionMethodsManager.getAll();
  }

  void goToListPage() {
    Get.offNamed(
      Routes.expenseList,
    );
  }

  void onResetTap() {}

  void onSaveTap() {
    if (formKey.currentState!.validate()) {
      if (transactionMethodsManager.selectedItem.value == null) {
        toast('Please select a transaction method');
        return;
      }

      toast('Field is valid');
      toast('Under development the API');
      // Get.back();
    }
  }
}
