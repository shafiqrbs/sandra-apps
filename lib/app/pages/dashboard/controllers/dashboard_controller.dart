import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/global_modal/prefs_settings_modal/prefs_settings_modal_view.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/tbd_round_button.dart';
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
    icon: TablerIcons.sort_ascending_letters,
    onTap: () => navigatePage(Routes.createSales),
    localeMethod: () => appLocalization.pos,
  ),
  TbdRoundButton(
    icon: TablerIcons.point_off,
    onTap: () => navigatePage(Routes.salesList),
    localeMethod: () => appLocalization.invoice,
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_bag,
    onTap: () => navigatePage(Routes.createPurchase),
    localeMethod: () => appLocalization.createPurchase,
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.purchaseList),
    localeMethod: () => appLocalization.purchaseList,
  ),
  TbdRoundButton(
    icon: TablerIcons.list,
    onTap: () => navigatePage(Routes.stockList),
    localeMethod: () => appLocalization.stockList,
  ),
  TbdRoundButton(
    icon: TablerIcons.list,
    onTap: () {
      toast(
        appLocalization.upcomingFeature,
      );
    },
    localeMethod: () => appLocalization.salesReturn,
  ),
  TbdRoundButton(
    text: appLocalization.stockList,
    icon: TablerIcons.list,
    onTap: () {
      toast(
        appLocalization.upcomingFeature,
      );
    },
    localeMethod: () => appLocalization.purchaseReturn,
  ),
];

List<Widget> accountingButtonList = [
  TbdRoundButton(
    icon: TablerIcons.robot_face,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customerList,
  ),
  TbdRoundButton(
    icon: TablerIcons.butterfly,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendorList,
  ),
  TbdRoundButton(
    icon: TablerIcons.butterfly,
    onTap: () => navigatePage(Routes.accountingSales),
    localeMethod: () => appLocalization.sales,
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.accountingPurchase),
    localeMethod: () => appLocalization.purchase,
  ),
];

List<Widget> configButtonList = [
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.settings),
    localeMethod: () => appLocalization.settings,
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () {
      Get.dialog(
        DialogPattern(
          title: 'title',
          subTitle: 'subTitle',
          child: PrefsSettingsModalView(),
        ),
      );
    },
    localeMethod: () => appLocalization.settings,
  ),
];

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
