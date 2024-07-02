import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/create_sales/controllers/create_sales_controller.dart';

//ignore: must_be_immutable
class CreateSalesView extends BaseView<CreateSalesController> {
  CreateSalesView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  