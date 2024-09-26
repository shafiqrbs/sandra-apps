import 'package:flutter/material.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/controllers/restaurant_home_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class RestaurantHomeView extends BaseView<RestaurantHomeController> {
  RestaurantHomeView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  