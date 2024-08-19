import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/core/widget/common_confirmation_modal.dart';
import 'package:sandra/app/entity/expense.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/add_expense_modal/add_expense_view.dart';

class ExpenseListController extends BaseController {
  final expenseList = Rx<List<Expense>?>(null);
  @override
  Future<void> onInit() async {
    super.onInit();
    await getExpenseList();
  }

  Future<void> showAddExpenseModal() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.addExpense,
        subTitle: '',
        child: AddExpenseView(),
      ),
    );
  }

  Future<void> getExpenseList() async {
    await dataFetcher(
      future: () async {
        final data = await services.getExpenseList();
        if (data != null) {
          expenseList.value = data;
        }
      },
    );
  }

  Future<void> deleteExpense({
    required String expenseId,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isDeleted;
      await dataFetcher(
        future: () async {
          isDeleted = await services.deleteExpense(
            id: expenseId,
          );
        },
      );
      if (isDeleted ?? false) {
        await getExpenseList();
      }
    }
  }

  Future<void> approveExpense({
    required String expenseId,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isApproved;
      await dataFetcher(
        future: () async {
          isApproved = await services.approveExpense(
            id: expenseId,
          );
        },
      );
      if (isApproved ?? false) {
        await getExpenseList();
      }
    }
  }
}
