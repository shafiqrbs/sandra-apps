import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/entity/expense_category.dart';
import '/app/entity/transaction_methods.dart';
import '/app/entity/user.dart';
import '/app/routes/app_pages.dart';

class AddExpenseController extends BaseController {
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

  void onResetTap() {
    amountController.value.clear();
    remarkController.clear();
    expenseCategoryManager.asController.selectedValue = null;
    userManager.asController.selectedValue = null;
    transactionMethodsManager.selectedItem.value = null;
  }

  Future<void> onSaveTap() async {
    if (userManager.asController.selectedValue == null) {
      Get.snackbar('Error', 'Please select a user',
        backgroundColor: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 4,
      );
      return;
    }
    if (expenseCategoryManager.asController.selectedValue == null) {
      toast('Please select a category');
      return;
    }
    if (transactionMethodsManager.selectedItem.value == null) {
      toast('Please select a transaction method');
      return;
    }

    if (amountController.value.text.isEmpty) {
      toast('Please enter amount');
      return;
    }
    if (formKey.currentState!.validate()) {
      bool? isSubmitted;
      await dataFetcher(
        future: () async {
          isSubmitted = await services.addExpense(
            amount: amountController.value.text,
            remark: remarkController.text,
            expenseCategoryId:
                expenseCategoryManager.asController.selectedValue!.categoryId,
            userId: userManager.asController.selectedValue!.userId,
            transactionMethodId:
                transactionMethodsManager.selectedItem.value!.methodId,
          );
        },
      );
      if (isSubmitted ?? false) {}
    }
  }
}
