import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/pages/restaurant_module/order_cart/views/order_cart_view.dart';
import '/app/core/base/base_controller.dart';

enum MenuView {
  list,
  grid,
}

class RestaurantHomeController extends BaseController {
  final searchController = TextEditingController();
  final menuView = Rx<MenuView?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void changeMenuView() {
    if (menuView.value == MenuView.list) {
      menuView.value = MenuView.grid;
    } else {
      menuView.value = MenuView.list;
    }
  }

  void goToOrderCart({
    required BuildContext context,
  }) {
    Get.dialog(
      OrderCartView(),
    );
  }
}
