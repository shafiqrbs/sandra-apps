import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 200,
              width: 200,
              child: Center(
                child: Text('Order Cart'),
              ),
            ),
          );
        });
  }
}
