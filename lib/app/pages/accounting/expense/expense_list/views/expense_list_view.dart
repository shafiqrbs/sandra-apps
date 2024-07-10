import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/list_button.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/expense/expense_list/controllers/expense_list_controller.dart';

//ignore: must_be_immutable
class ExpenseListView extends BaseView<ExpenseListController> {
  ExpenseListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Text(
        'expense_list'.tr,
        style: TextStyle(
          color: colors.backgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        AppBarButtonGroup(
          children: [
            AddButton(
              onTap: controller.showAddExpenseModal,
            ),
            QuickNavigationButton(),
          ],
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
