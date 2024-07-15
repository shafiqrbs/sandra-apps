import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';
import 'package:sandra/app/core/widget/tbd_round_button.dart';

import '/app/core/base/base_controller.dart';
import '/app/routes/app_pages.dart';

enum SelectedTab {
  dashboard,
  report,
}

enum SelectedButtonGroup {
  inventory,
  accounting,
  config,
}

List<Widget> inventoryButtonList = [
  TbdRoundButton(
    text: appLocalization.createSales,
    icon: TablerIcons.sort_ascending_letters,
    onTap: () => navigatePage(Routes.createSales),
    localeMethod: () => appLocalization.createSales,
  ),
];

List<Widget> accountingButtonList = [];

List<Widget> configButtonList = [];

class DashboardController extends BaseController {
  final selectedTab = SelectedTab.dashboard.obs;
  final selectedButtonGroup = SelectedButtonGroup.inventory.obs;

  List<Widget> dashboardButtonList = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    dashboardButtonList = inventoryButtonList;
  }

  void changeTab(SelectedTab dashboard) {
    selectedTab.value = dashboard;
  }

  void goToSales() {
    Get.toNamed(
      Routes.createSales,
    );
  }

  void goToSalesList() {
    Get.toNamed(
      Routes.salesList,
    );
  }

  void gotoExpenseScreen() {}

  void gotoPurchaseScreen() {}

  void goToStockList() {}

  Future<void> goToClearLicense() async {
    await prefs.setIsLicenseValid(
      isLicenseValid: false,
    );
    await prefs.setIsLogin(
      isLogin: false,
    );
    Get.offAllNamed(
      Routes.splash,
    );
  }

  void goToSettings() {
    Get.toNamed(
      Routes.settings,
    );
  }

  void updateSelectedButtonGroup(SelectedButtonGroup group) {
    selectedButtonGroup.value = group;
    if (group == SelectedButtonGroup.inventory) {
      dashboardButtonList = inventoryButtonList;
    }
    if (group == SelectedButtonGroup.accounting) {
      dashboardButtonList = accountingButtonList;
    }
    if (group == SelectedButtonGroup.config) {
      dashboardButtonList = configButtonList;
    }
  }
}
