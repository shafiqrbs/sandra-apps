import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/expense/controllers/expense_controller.dart';

//ignore: must_be_immutable
class ExpenseView extends BaseView<ExpenseController> {
  ExpenseView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  