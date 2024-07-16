import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/accounting_sales/controllers/accounting_sales_controller.dart';

//ignore: must_be_immutable
class AccountingSalesView extends BaseView<AccountingSalesController> {
  AccountingSalesView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
