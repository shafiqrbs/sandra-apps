import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/entity/restaurant/restaurant_table.dart';
import 'package:sandra/app/entity/stock.dart';
import 'package:sandra/app/pages/restaurant_module/order_cart/views/order_cart_view.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/views/menu_bottom_sheet.dart';
import 'package:sandra/app/service/parser.dart';
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
  final List<String> menuItems = [
    'Pizza',
    'Burger',
    'Soup',
    'Salad',
    'Set menu',
    'Juice Special',
    'Sandwich',
    'Pasta',
    'Meat',
    'Fruits',
  ];
  final selectedFoodList = <int>[].obs;
  final selectedTableIndex = 0.obs;
  final tableList = Rx<List<RestaurantTable>?>(null);
  final stockList = Rx<List<Stock?>?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    await dataFetcher(
      future: () async {
        await getRestaurantTableList();
        await getStockItems();
      },
    );
  }

  Future<void> getRestaurantTableList() async {
    final response = await services.getRestaurantTableList();
    if (response != null) {
      tableList.value = response;
    }
  }

  Future<void> getStockItems() async {
    final response = await services.getStockItems();
    print('stock items: $response');
    if (response != null) {
      final stockData = await parseList(
        list: response,
        fromJson: Stock.fromJson,
      );
      stockList.value = stockData;
    }
  }

  void changeMenuView() {
    if (menuView.value == MenuView.list) {
      menuView.value = MenuView.grid;
    } else {
      menuView.value = MenuView.list;
    }
  }

  void changeBottomStatus(BottomStatus status) {
    bottomStatus.value = status;
  }

  void goToOrderCart({
    required BuildContext context,
  }) {
    Get.dialog(
      OrderCartView(),
    );
  }

  void openMenuBottomSheet({
    required BuildContext context,
  }) {
    MenuBottomSheet(
      context: context,
      menuItems: menuItems,
    ).showMenuFromLeft();
  }

  void selectFoodItem(int index) {
    if (selectedFoodList.contains(index)) {
      selectedFoodList.remove(index);
    } else {
      selectedFoodList.add(index);
    }
  }
}
