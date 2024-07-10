import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/expense_list/controllers/expense_list_controller.dart';

//ignore: must_be_immutable
class ExpenseListView extends BaseView<ExpenseListController> {
  ExpenseListView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  