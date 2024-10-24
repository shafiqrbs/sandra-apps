import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/widget/no_record_found_view.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/bank.dart';
import 'package:sandra/app/entity/financial_data.dart';
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

ValueNotifier<Map<String, Color>> colorList = ValueNotifier({
  'blue': ColorSchema().solidBlueColor,
  'green': ColorSchema().solidGreenColor,
  'red': ColorSchema().solidRedColor,
  'yellow': ColorSchema().solidYellowColor,
  'grey': ColorSchema().solidGreyColor,
  'purple': ColorSchema().solidPurpleColor,
  'orange': ColorSchema().solidOrangeColor,
  'olive': ColorSchema().solidOliveColor,
  'marun': ColorSchema().solidMarunColor,
  'navyBlue': ColorSchema().solidNavyBlueColor,
});

List<Widget> inventoryButtonList = [
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.salesList),
    localeMethod: () => appLocalization.sales,
    bgColor: colorList.value['blue'],
  ),
  TbdRoundButton(
    icon: TablerIcons.truck_delivery,
    onTap: () => navigatePage(Routes.purchaseList),
    localeMethod: () => appLocalization.purchase,
    bgColor: colorList.value['orange'],
  ),
  TbdRoundButton(
    icon: TablerIcons.packages,
    onTap: () => navigatePage(Routes.stockList),
    localeMethod: () => appLocalization.stocks,
    bgColor: colorList.value['green'],
  ),
  TbdRoundButton(
    icon: TablerIcons.credit_card_refund,
    onTap: () {
      showSnackBar(
        type: SnackBarType.warning,
        title: appLocalization.upcomingFeature,
        message: appLocalization.comingSoon,
      );
    },
    localeMethod: () => appLocalization.salesReturn,
    bgColor: colorList.value['navyBlue'],
  ),
  TbdRoundButton(
    icon: TablerIcons.users_group,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customer,
    bgColor: colorList.value['purple'],
  ),
  TbdRoundButton(
    icon: TablerIcons.building_store,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList.value['olive'],
  ),
  TbdRoundButton(
    text: appLocalization.stockList,
    icon: TablerIcons.receipt_refund,
    onTap: () {
      showSnackBar(
        type: SnackBarType.warning,
        title: appLocalization.upcomingFeature,
        message: appLocalization.comingSoon,
      );
    },
    localeMethod: () => appLocalization.purchaseReturn,
    bgColor: colorList.value['red'],
  ),
];

List<Widget> accountingButtonList = [
  TbdRoundButton(
    icon: TablerIcons.wallet,
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
    bgColor: colorList.value['marun'],
  ),
  TbdRoundButton(
    icon: TablerIcons.exposure,
    onTap: () => navigatePage(Routes.expenseList),
    localeMethod: () => appLocalization.expense,
    bgColor: colorList.value['grey'],
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.accountingSales),
    localeMethod: () => appLocalization.sales,
    bgColor: colorList.value['blue'],
  ),
  TbdRoundButton(
    icon: TablerIcons.users_group,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customer,
    bgColor: colorList.value['purple'],
  ),
  TbdRoundButton(
    icon: TablerIcons.truck_delivery,
    onTap: () => navigatePage(Routes.accountingPurchase),
    localeMethod: () => appLocalization.purchase,
    bgColor: colorList.value['orange'],
  ),
  TbdRoundButton(
    icon: TablerIcons.building_store,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList.value['olive'],
  ),
  TbdRoundButton(
    icon: TablerIcons.report,
    onTap: () {
      showSnackBar(
        type: SnackBarType.warning,
        title: appLocalization.upcomingFeature,
        message: appLocalization.comingSoon,
      );
    },
    localeMethod: () => appLocalization.journal,
    bgColor: colorList.value['red'],
  ),
];

List<Widget> createButtonList = [
  TbdRoundButton(
    icon: TablerIcons.users_plus,
    onTap: DashboardController().showAddCustomerModal,
    localeMethod: () => appLocalization.customer,
    bgColor: colorList.value['purple'],
  ),
  TbdRoundButton(
    icon: TablerIcons.building_store,
    onTap: DashboardController().showAddVendorModal,
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList.value['olive'],
  ),
  TbdRoundButton(
    icon: TablerIcons.box,
    onTap: DashboardController().showAddStockModal,
    localeMethod: () => appLocalization.product,
    bgColor: colorList.value['green'],
  ),
];

List<Widget> configButtonList = [
  TbdRoundButton(
    icon: TablerIcons.settings_2,
    onTap: () => navigatePage(Routes.settings),
    localeMethod: () => appLocalization.global,
    bgColor: colorList.value['green'],
  ),
  TbdRoundButton(
    icon: TablerIcons.database_cog,
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
    bgColor: colorList.value['navyBlue'],
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
    bgColor: colorList.value['marun'],
  ),
  TbdRoundButton(
    icon: TablerIcons.refresh_dot,
    onTap: () => navigatePage(Routes.offlineSyncProcess),
    localeMethod: () => appLocalization.offlineSyncProcess,
    bgColor: colorList.value['olive'],
  ),
];

class DashboardController extends BaseController {
  final selectedTab = SelectedTab.dashboard.obs;
  final selectedButtonGroup = SelectedButtonGroup.inventory.obs;
  final showOnlineController = ValueNotifier<bool>(false).obs;
  final isOnline = false.obs;

  List<Widget> dashboardButtonList = [];

  final financialData = Rx<FinancialData?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    dashboardButtonList = inventoryButtonList;
    isOnline.value = await prefs.getIsSalesOnline();
    if (isOnline.value) {
      await fetchFinancialData();
    }
  }

  Future<void> fetchFinancialData() async {
    FinancialData? data;

    await dataFetcher(
      future: () async {
        data = await services.getFinancialData();
      },
    );
    if (data != null) {
      financialData.value = data;
    }
  }

  void goToSales() {
    if (SetUp().mainAppName == 'restaurant') {
      Get.toNamed(
        Routes.restaurantHome,
      );
    } else {
      Get.toNamed(
        Routes.createSales,
      );
    }
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
    if (isNewReceived ?? false) {
      Get.toNamed(Routes.accountingSales);
    }
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
    if (isNewReceived ?? false) {
      Get.toNamed(Routes.accountingPurchase);
    }
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
    update();
    await prefs.setIsSalesOnline(
      isSalesOnline: isOnline.value,
    );
    if (isOnline.value) {
      await fetchFinancialData();
    } else {
      financialData.value = null;
    }
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

  Future<void> changeTheme() async {
    showSnackBar(
      type: SnackBarType.warning,
      title: appLocalization.upcomingFeature,
      message: appLocalization.comingSoon,
    );
    return;
    // Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    ColorSchema.fromJson(
      Get.isDarkMode ? darkColor : lightColor,
    );
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    await prefs.setIsEnableDarkMode(isEnableDarkMode: Get.isDarkMode);
    await Get.forceAppUpdate();

    print('pref theme: ${await prefs.getIsEnableDarkMode()}');
    print('Current Theme: ${Get.isDarkMode ? 'Dark' : 'Light'}');
    print('Primary Color: ${ColorSchema().primaryColor900}');
  }

  void goToRestaurantHome() {
    Get.toNamed(
      Routes.restaurantHome,
    );
  }

  Future<void> onTransactionOverviewTap(TransactionOverview item) async {
    List<Bank>? list;
    await dataFetcher(
      future: () async {
        list = await services.getBankList();
      },
    );

    if (list != null && list!.isNotEmpty) {
      await Get.dialog(
        DialogPattern(
          title: item.name ?? '',
          subTitle: '',
          child: list?.isEmpty ?? false
              ? NoRecordFoundView()
              : Container(
                  height: Get.height * 0.5,
                  margin: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: list!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final bank = list![index];
                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                          left: 4,
                          right: 4,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              bank.name ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              bank.amount ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      );
    } else {
      showSnackBar(
        type: SnackBarType.error,
        title: appLocalization.error,
        message: appLocalization.noDataFound,
      );
    }
  }
}
