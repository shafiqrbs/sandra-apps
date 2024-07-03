import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/customer_list/controllers/customer_list_controller.dart';

//ignore: must_be_immutable
class CustomerListView extends BaseView<CustomerListController> {
  CustomerListView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Column();
  }
}
  