import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import 'package:sandra/app/global_modal/add_expense_modal/add_expense_view.dart';
import 'package:sandra/app/global_modal/add_product_modal/add_product_modal_view.dart';
import 'package:sandra/app/global_modal/add_vendor_modal/add_vendor_modal_view.dart';
import 'package:sandra/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';
import 'package:sandra/app/global_modal/sync_modal/sync_modal_view.dart';
import 'package:sandra/app/global_modal/vendor_payment_modal/vendor_payment_modal_view.dart';
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
  create,
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

List<Widget> createButtonList = [
  TbdRoundButton(
    icon: TablerIcons.user_plus,
    onTap: DashboardController().showAddCustomerModal,
    localeMethod: () => appLocalization.customer,
    bgColor: colorList[0],
  ),
  TbdRoundButton(
    icon: TablerIcons.user_heart,
    onTap: DashboardController().showAddVendorModal,
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList[1],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: DashboardController().showAddStockModal,
    localeMethod: () => appLocalization.product,
    bgColor: colorList[2],
  ),
];

List<Widget> inventoryButtonList = [
  TbdRoundButton(
    icon: TablerIcons.user,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customer,
    bgColor: colorList[0],
  ),
  TbdRoundButton(
    icon: TablerIcons.users,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList[1],
  ),
  TbdRoundButton(
    icon: TablerIcons.file_description,
    onTap: () => navigatePage(Routes.salesList),
    localeMethod: () => appLocalization.invoice,
    bgColor: colorList[2],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.purchaseList),
    localeMethod: () => appLocalization.purchase,
    bgColor: colorList[3],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_bag,
    onTap: () => navigatePage(Routes.createPurchase),
    localeMethod: () => appLocalization.order,
    bgColor: colorList[4],
  ),
  TbdRoundButton(
    icon: TablerIcons.list,
    onTap: () => navigatePage(Routes.stockList),
    localeMethod: () => appLocalization.stocks,
    bgColor: colorList[5],
  ),
  TbdRoundButton(
    icon: TablerIcons.receipt_refund,
    onTap: () {
      toast(
        appLocalization.upcomingFeature,
      );
    },
    localeMethod: () => appLocalization.salesReturn,
    bgColor: colorList[6],
  ),
  TbdRoundButton(
    text: appLocalization.stockList,
    icon: TablerIcons.credit_card_refund,
    onTap: () {
      toast(
        appLocalization.upcomingFeature,
      );
    },
    localeMethod: () => appLocalization.purchaseReturn,
    bgColor: colorList[1],
  ),
];

List<Widget> accountingButtonList = [
  TbdRoundButton(
    icon: TablerIcons.credit_card_pay,
    onTap: () async {
      await Get.dialog(
        DialogPattern(
          title: appLocalization.createExpense,
          subTitle: appLocalization.createExpenseDetails,
          child: AddExpenseView(),
        ),
      );
    },
    localeMethod: () => appLocalization.newExpense,
    bgColor: colorList[0],
  ),
  TbdRoundButton(
    icon: TablerIcons.indent_increase,
    onTap: () => navigatePage(Routes.expenseList),
    localeMethod: () => appLocalization.expense,
    bgColor: colorList[1],
  ),
  TbdRoundButton(
    icon: TablerIcons.user,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customer,
    bgColor: colorList[2],
  ),
  TbdRoundButton(
    icon: TablerIcons.butterfly,
    onTap: () => navigatePage(Routes.accountingSales),
    localeMethod: () => appLocalization.sales,
    bgColor: colorList[3],
  ),
  TbdRoundButton(
    icon: TablerIcons.users,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList[4],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.accountingPurchase),
    localeMethod: () => appLocalization.purchase,
    bgColor: colorList[5],
  ),
  TbdRoundButton(
    icon: TablerIcons.report,
    onTap: () {
      toast(
        appLocalization.upcomingFeature,
      );
    },
    localeMethod: () => appLocalization.journal,
    bgColor: colorList[6],
  ),
];

List<Widget> configButtonList = [
  TbdRoundButton(
    icon: TablerIcons.settings_2,
    onTap: () => navigatePage(Routes.settings),
    localeMethod: () => appLocalization.global,
    bgColor: colorList[0],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () {
      Get.dialog(
        DialogPattern(
          title: appLocalization.inventory,
          subTitle: '',
          child: PrefsSettingsModalView(),
        ),
      );
    },
    localeMethod: () => appLocalization.inventory,
    bgColor: colorList[1],
  ),
  TbdRoundButton(
    icon: TablerIcons.rotate_rectangle,
    onTap: () {
      Get.dialog(
        DialogPattern(
          title: appLocalization.sync,
          subTitle: '',
          child: SyncModalView(),
        ),
      );
    },
    localeMethod: () => appLocalization.sync,
    bgColor: colorList[2],
  ),
];

class DashboardController extends BaseController {
  final selectedTab = SelectedTab.dashboard.obs;
  final selectedButtonGroup = SelectedButtonGroup.inventory.obs;
  final showOnlineController = ValueNotifier<bool>(false).obs;
  final isOnline = false.obs;

  List<Widget> dashboardButtonList = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    dashboardButtonList = inventoryButtonList;
    isOnline.value = await prefs.getIsSalesOnline();
  }

  void changeTab(SelectedTab dashboard) {
    selectedTab.value = dashboard;
  }

  void goToSales() {
    Get.toNamed(
      Routes.createSales,
    );
  }

  Future<void> showCustomerReceiveModal() async {
    final isNewReceived = await Get.dialog(
      DialogPattern(
        title: appLocalization.newReceive,
        subTitle: '',
        child: CustomerReceiveModalView(
          customer: null,
        ),
      ),
    );
  }

  Future<void> showVendorPaymentModal() async {
    final isNewReceived = await Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: 'subTitle',
        child: VendorPaymentModalView(
          vendor: null,
        ),
      ),
    );
    if (isNewReceived == true) {}
  }

  void showAddCustomerModal() {
    final result = Get.dialog(
      DialogPattern(
        title: appLocalization.newCustomer,
        subTitle: '',
        child: AddCustomerModalView(),
      ),
    );
  }

  void showAddVendorModal() {
    final result = Get.dialog(
      DialogPattern(
        title: appLocalization.addVendor,
        subTitle: '',
        child: AddVendorModalView(),
      ),
    );
  }

  Future<void> showAddStockModal() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.addProduct,
        subTitle: '',
        child: AddProductModalView(),
      ),
    );
    if (result != null) {
      print(result);
    }
  }

  void goToSalesList() {
    Get.toNamed(
      Routes.salesList,
    );
  }

  void goToPurchaseList() {
    Get.toNamed(
      Routes.purchaseList,
    );
  }

  void goToExpenseList() {
    Get.toNamed(
      Routes.expenseList,
    );
  }

  void goToDueCustomerList() {
    Get.toNamed(
      Routes.dueCustomerList,
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
    if (group == SelectedButtonGroup.create) {
      dashboardButtonList = createButtonList;
    }
    if (group == SelectedButtonGroup.config) {
      dashboardButtonList = configButtonList;
    }
  }

  Future<void> cashOnTap() async {}

  Future<void> bankOnTap() async {}

  Future<void> mobileOnTap() async {}

  Future<void> onTapIsOnline() async {
    isOnline.value = !isOnline.value;
    await prefs.setIsSalesOnline(
      isSalesOnline: isOnline.value,
    );
  }
}
