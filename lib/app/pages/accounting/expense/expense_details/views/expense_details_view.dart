import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/expense/expense_details/controllers/expense_details_controller.dart';

//ignore: must_be_immutable
class ExpenseDetailsView extends BaseView<ExpenseDetailsController> {
  ExpenseDetailsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
