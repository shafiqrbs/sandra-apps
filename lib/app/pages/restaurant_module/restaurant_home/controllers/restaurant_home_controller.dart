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
}
