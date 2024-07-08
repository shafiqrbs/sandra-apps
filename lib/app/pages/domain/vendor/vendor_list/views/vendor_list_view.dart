import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/domain/vendor/vendor_list/controllers/vendor_list_controller.dart';

//ignore: must_be_immutable
class VendorListView extends BaseView<VendorListController> {
  VendorListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
