import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/inventory/purchase/purchase_list/controllers/purchase_list_controller.dart';

//ignore: must_be_immutable
class PurchaseListView extends BaseView<PurchaseListController> {
  PurchaseListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
