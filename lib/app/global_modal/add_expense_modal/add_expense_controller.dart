import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/entity/expense_category.dart';
import '/app/entity/user.dart';
import '/app/routes/app_pages.dart';

class AddExpenseController extends BaseController {
  final userManager = UserManager();
  final expenseCategoryManager = ExpenseCategoryManager();
  final amountController = TextEditingController();
  final remarkController = TextEditingController();
  @override
  Future<void> onInit() async {
    super.onInit();
    await expenseCategoryManager.fillAsController();
    await userManager.fillAsController();
  }

  void goToListPage() {
    Get.offNamed(
      Routes.expenseList,
    );
  }
}
