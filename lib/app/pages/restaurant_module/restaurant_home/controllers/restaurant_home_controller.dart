import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/pages/restaurant_module/order_cart/views/order_cart_view.dart';
import '/app/core/base/base_controller.dart';

enum MenuView {
  list,
  grid,
}

enum BottomStatus {
  order,
  kitchen,
  hold,
  reserved,
  free,
}

class RestaurantHomeController extends BaseController {
  final searchController = TextEditingController();
  final menuView = Rx<MenuView?>(null);
  final bottomStatus = Rx<BottomStatus>(BottomStatus.hold);

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

  void changeBottomStatus (BottomStatus status) {
    bottomStatus.value = status;
  }

  void goToOrderCart({
    required BuildContext context,
  }) {
    Get.dialog(
      OrderCartView(),
    );
  }
}
