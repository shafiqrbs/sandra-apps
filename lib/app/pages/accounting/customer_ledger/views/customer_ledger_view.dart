import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/customer_ledger/controllers/customer_ledger_controller.dart';

//ignore: must_be_immutable
class CustomerLedgerView extends BaseView<CustomerLedgerController> {
  CustomerLedgerView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  