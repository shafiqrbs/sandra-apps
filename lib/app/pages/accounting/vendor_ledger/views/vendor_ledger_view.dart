import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/vendor_ledger/controllers/vendor_ledger_controller.dart';

//ignore: must_be_immutable
class VendorLedgerView extends BaseView<VendorLedgerController> {
  VendorLedgerView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  