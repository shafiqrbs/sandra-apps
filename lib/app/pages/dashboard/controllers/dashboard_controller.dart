import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/global_modal/prefs_settings_modal/prefs_settings_modal_view.dart';

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

List<Color> colorList = [
  const Color(0xff1E90FF),
  const Color(0xff004D40),
  const Color(0xffFF6F61),
  const Color(0xff32CD32),
  const Color(0xff4CBB17),
  const Color(0xff5D6D7E),
  const Color(0xff6D28D9),
];


List<Widget> inventoryButtonList = [
  TbdRoundButton(
    icon: TablerIcons.sort_ascending_letters,
    onTap: () => navigatePage(Routes.createSales),
    localeMethod: () => appLocalization.pos,
    bgColor: colorList[0],
  ),
  TbdRoundButton(
    icon: TablerIcons.point_off,
    onTap: () => navigatePage(Routes.salesList),
    localeMethod: () => appLocalization.invoice,
    bgColor: colorList[1],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_bag,
    onTap: () => navigatePage(Routes.createPurchase),
    localeMethod: () => appLocalization.createPurchase,
    bgColor: colorList[2],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.purchaseList),
    localeMethod: () => appLocalization.purchaseList,
    bgColor: colorList[3],
  ),
  TbdRoundButton(
    icon: TablerIcons.list,
    onTap: () => navigatePage(Routes.stockList),
    localeMethod: () => appLocalization.stockList,
    bgColor: colorList[4],
  ),
  TbdRoundButton(
    icon: TablerIcons.list,
    onTap: () {
      toast(
        appLocalization.upcomingFeature,
      );
    },
    localeMethod: () => appLocalization.salesReturn,
    bgColor: colorList[5],
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
    bgColor: colorList[6],
  ),
];

List<Widget> accountingButtonList = [
  TbdRoundButton(
    icon: TablerIcons.robot_face,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customerList,
    bgColor: colorList[0],
  ),
  TbdRoundButton(
    icon: TablerIcons.butterfly,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendorList,
    bgColor: colorList[1],
  ),
  TbdRoundButton(
    icon: TablerIcons.butterfly,
    onTap: () => navigatePage(Routes.accountingSales),
    localeMethod: () => appLocalization.sales,
    bgColor: colorList[2],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.accountingPurchase),
    localeMethod: () => appLocalization.purchase,
    bgColor: colorList[3],
  ),
];

List<Widget> configButtonList = [
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.settings),
    localeMethod: () => appLocalization.settings,
    bgColor: colorList[0],
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
    bgColor: colorList[1],
  ),
];

class DashboardController extends BaseController {
  final selectedTab = SelectedTab.dashboard.obs;
  final selectedButtonGroup = SelectedButtonGroup.inventory.obs;
  final showOnlineController = ValueNotifier<bool>(false).obs;

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
