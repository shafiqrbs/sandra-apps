import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/utils/test_functions.dart';
import '/app/entity/sales.dart';
import '/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import '/app/global_modal/add_expense_modal/add_expense_view.dart';
import '/app/global_modal/add_product_modal/add_product_modal_view.dart';
import '/app/global_modal/add_vendor_modal/add_vendor_modal_view.dart';
import '/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';
import '/app/global_modal/sync_modal/sync_modal_view.dart';
import '/app/global_modal/vendor_payment_modal/vendor_payment_modal_view.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/tbd_round_button.dart';
import '/app/global_modal/prefs_settings_modal/prefs_settings_modal_view.dart';
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

final colorList = [
  ColorSchema().solidBlueColor,
  ColorSchema().solidGreenColor,
  ColorSchema().solidRedColor,
  ColorSchema().solidLiteGreenColor,
  ColorSchema().solidGreyColor,
  ColorSchema().solidPurpleColor,
  ColorSchema().solidGreenColor,
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
    icon: TablerIcons.list,
    onTap: () => navigatePage(Routes.stockList),
    localeMethod: () => appLocalization.stocks,
    bgColor: colorList[0],
  ),
  TbdRoundButton(
    icon: TablerIcons.file_description,
    onTap: () => navigatePage(Routes.salesList),
    localeMethod: () => appLocalization.invoice,
    bgColor: colorList[1],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.purchaseList),
    localeMethod: () => appLocalization.purchase,
    bgColor: colorList[2],
  ),
  TbdRoundButton(
    icon: TablerIcons.receipt_refund,
    onTap: () {
      showSnackBar(
        title: appLocalization.upcomingFeature,
        message: appLocalization.comingSoon,
      );
    },
    localeMethod: () => appLocalization.salesReturn,
    bgColor: colorList[3],
  ),
  TbdRoundButton(
    icon: TablerIcons.user,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customer,
    bgColor: colorList[4],
  ),
  TbdRoundButton(
    icon: TablerIcons.users,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList[5],
  ),
  TbdRoundButton(
    text: appLocalization.stockList,
    icon: TablerIcons.credit_card_refund,
    onTap: () {
      showSnackBar(
        title: appLocalization.upcomingFeature,
        message: appLocalization.comingSoon,
      );
    },
    localeMethod: () => appLocalization.purchaseReturn,
    bgColor: colorList[6],
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
          title: appLocalization.inventorySettings,
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
          title: appLocalization.synchronization,
          subTitle: appLocalization.importDataToEnsureEverythingIsUpToDate,
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

  void goToPo() {
    Get.toNamed(
      Routes.createPurchase,
    );
  }

  Future<void> showCustomerReceiveModal() async {
    final isNewReceived = await Get.dialog(
      DialogPattern(
        title: appLocalization.salesReceive,
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
        title: appLocalization.payment,
        subTitle: '',
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
        title: appLocalization.createVendor,
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
      if (kDebugMode) {
        print('Product added');
      }
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

  Future<void> clearLicense() async {
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

  Future<void> logOut() async {
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

  Future<void> generateDummySales({
    int? isHold,
  }) async {
    final salesList = List.generate(
      1000,
      (index) => generateRandomSales(
        isHold: isHold,
      ),
    );

    await dbHelper.insertList(
      deleteBeforeInsert: true,
      tableName: dbTables.tableSale,
      dataList: salesList.map((e) => e.toJson()).toList(),
    );
  }

  void generateDummyPurchase({
    int? isHold,
  }) {
    final purchaseList = List.generate(
      1000,
      (index) => generateRandomPurchase(
        isHold: isHold,
      ),
    );

    dbHelper.insertList(
      deleteBeforeInsert: true,
      tableName: dbTables.tablePurchase,
      dataList: purchaseList.map((e) => e.toJson()).toList(),
    );
  }
}
