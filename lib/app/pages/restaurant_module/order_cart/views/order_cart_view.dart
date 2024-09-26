import 'package:flutter/material.dart';
import 'package:sandra/app/pages/restaurant_module/order_cart/controllers/order_cart_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class OrderCartView extends BaseView<OrderCartController> {
  OrderCartView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  