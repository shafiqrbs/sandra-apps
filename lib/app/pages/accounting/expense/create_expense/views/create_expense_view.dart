import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/expense/create_expense/controllers/create_expense_controller.dart';

//ignore: must_be_immutable
class CreateExpenseView extends BaseView<CreateExpenseController> {
  CreateExpenseView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
