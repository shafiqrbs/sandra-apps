import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/show_snack_bar.dart';
import 'package:sandra/app/entity/bank.dart';
import 'package:sandra/app/entity/financial_data.dart';
import 'package:sandra/app/entity/onboard_entity.dart';
import 'package:sandra/app/global_modal/add_brand_modal/add_brand_modal_view.dart';
import 'package:sandra/app/global_modal/add_category_modal/add_category_modal_view.dart';
import 'package:sandra/app/global_modal/printer_setup_modal/printer_setup_modal_view.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '/app/core/utils/test_functions.dart';
import '/app/core/widget/tbd_round_button.dart';
import '/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import '/app/global_modal/add_expense_modal/add_expense_view.dart';
import '/app/global_modal/add_product_modal/add_product_modal_view.dart';
import '/app/global_modal/add_vendor_modal/add_vendor_modal_view.dart';
import '/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';
import '/app/global_modal/prefs_settings_modal/prefs_settings_modal_view.dart';
import '/app/global_modal/sync_modal/sync_modal_view.dart';
import '/app/global_modal/vendor_payment_modal/vendor_payment_modal_view.dart';

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
    permission: isRoleSales,
  ),
  TbdRoundButton(
    icon: TablerIcons.truck_delivery,
    onTap: () => navigatePage(Routes.purchaseList),
    localeMethod: () => appLocalization.purchase,
    bgColor: colorList.value['orange'],
    permission: isRolePurchase,
  ),
  TbdRoundButton(
    icon: TablerIcons.packages,
    onTap: () => navigatePage(Routes.stockList),
    localeMethod: () => appLocalization.stocks,
    bgColor: colorList.value['green'],
    permission: isRoleStock,
  ),
  TbdRoundButton(
    icon: TablerIcons.credit_card_refund,
    onTap: () => navigatePage(Routes.salesReturnListPage),
    localeMethod: () => appLocalization.salesReturn,
    bgColor: colorList.value['navyBlue'],
    permission: isRoleManager,
  ),
  TbdRoundButton(
    icon: TablerIcons.users_group,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customer,
    bgColor: colorList.value['purple'],
    permission: isRoleSales,
  ),
  TbdRoundButton(
    icon: TablerIcons.building_store,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList.value['olive'],
    permission: isRolePurchase,
  ),
  /*TbdRoundButton(
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
    permission: isRoleManager,
  ),*/
  TbdRoundButton(
    text: appLocalization.brand,
    icon: TablerIcons.clipboard_data,
    onTap: () => navigatePage(Routes.brandListPage),
    localeMethod: () => appLocalization.brand,
    bgColor: colorList.value['olive'],
    permission: isRoleStock,
  ),
  TbdRoundButton(
      text: appLocalization.category,
      icon: TablerIcons.category,
      onTap: () => navigatePage(Routes.categoryListPage),
      localeMethod: () => appLocalization.category,
      bgColor: colorList.value['purple'],
      permission: isRoleStock),
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
    permission: isRoleExpense,
  ),
  TbdRoundButton(
    icon: TablerIcons.exposure,
    onTap: () => navigatePage(Routes.expenseList),
    localeMethod: () => appLocalization.expense,
    bgColor: colorList.value['grey'],
    permission: isRoleExpense,
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.accountingSales),
    localeMethod: () => appLocalization.sales,
    bgColor: colorList.value['blue'],
    permission: isRoleSales,
  ),
  TbdRoundButton(
    icon: TablerIcons.users_group,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customer,
    bgColor: colorList.value['purple'],
    permission: isRoleSales,
  ),
  TbdRoundButton(
    icon: TablerIcons.truck_delivery,
    onTap: () => navigatePage(Routes.accountingPurchase),
    localeMethod: () => appLocalization.purchase,
    bgColor: colorList.value['orange'],
    permission: isRolePurchase,
  ),
  TbdRoundButton(
    icon: TablerIcons.building_store,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList.value['olive'],
    permission: isRolePurchase,
  ),
  /*TbdRoundButton(
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
    permission: isRoleManager,
  ),*/
];

List<Widget> createButtonList = [
  TbdRoundButton(
    icon: TablerIcons.users_plus,
    onTap: DashboardController().showAddCustomerModal,
    localeMethod: () => appLocalization.customer,
    bgColor: colorList.value['purple'],
    permission: isRoleSales,
  ),
  TbdRoundButton(
    icon: TablerIcons.building_store,
    onTap: DashboardController().showAddVendorModal,
    localeMethod: () => appLocalization.vendor,
    bgColor: colorList.value['olive'],
    permission: isRolePurchase,
  ),
  TbdRoundButton(
    icon: TablerIcons.box,
    onTap: DashboardController().showAddStockModal,
    localeMethod: () => appLocalization.product,
    bgColor: colorList.value['green'],
    permission: isRoleStock,
  ),
  TbdRoundButton(
    icon: TablerIcons.clipboard_data,
    onTap: DashboardController().showAddBrandModal,
    localeMethod: () => appLocalization.brand,
    bgColor: colorList.value['olive'],
    permission: isRoleStock,
  ),
  TbdRoundButton(
    icon: TablerIcons.category,
    onTap: DashboardController().showAddCategoryModal,
    localeMethod: () => appLocalization.category,
    bgColor: colorList.value['purple'],
    permission: isRoleStock,
  ),
];

List<Widget> configButtonList = [
  TbdRoundButton(
    icon: TablerIcons.settings_2,
    onTap: () => navigatePage(Routes.settings),
    localeMethod: () => appLocalization.global,
    bgColor: colorList.value['green'],
    permission: true,
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
    permission: isRoleManager,
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
    permission: isRoleSales || isRolePurchase,
  ),
  TbdRoundButton(
    icon: TablerIcons.refresh_dot,
    onTap: () => navigatePage(Routes.offlineSyncProcess),
    localeMethod: () => appLocalization.offlineSyncProcess,
    bgColor: colorList.value['olive'],
    permission: isRoleSales || isRolePurchase,
  ),
  TbdRoundButton(
    icon: TablerIcons.users_group,
    onTap: () => navigatePage(Routes.userListPage),
    localeMethod: () => appLocalization.user,
    bgColor: colorList.value['marun'],
    permission: isRoleManager,
  ),
  TbdRoundButton(
    icon: TablerIcons.printer,
    onTap: () {
      Get.dialog(
        DialogPattern(
          title: appLocalization.printerSetup,
          subTitle: '',
          child: PrinterSetupModalView(),
        ),
      );
    },
    localeMethod: () => appLocalization.printerSetup,
    bgColor: colorList.value['marun'],
    permission: true,
  ),
];

class DashboardController extends BaseController {
  final selectedTab = SelectedTab.dashboard.obs;
  final selectedButtonGroup = SelectedButtonGroup.inventory.obs;
  final showOnlineController = ValueNotifier<bool>(false).obs;
  final isOnline = ValueNotifier(false);
  final onBoardSetupData = Rx<OnboardEntity?>(null);

  List<Widget> dashboardButtonList = [];

  final financialData = Rx<FinancialData?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    dashboardButtonList = inventoryButtonList;
    isOnline.value = await prefs.getIsDashboardOnline();
    await setSalesAndPurchaseOnline(isOnline.value);
    await dataFetcher(
      future: () async {
        await getOnboardSetup();
      },
    );
    /*if (isOnline.value) {
      await prefs.setIsSalesOnline(
        isSalesOnline: true,
      );
      await fetchOnlineFinancialData();
    } else {
      await fetchOfflineFinancialData();
    }*/
  }

  Future<void> getOnboardSetup() async {
    final response = await services.getOnboardSetup();
    if (response != null) {
      onBoardSetupData.value = response;
    }
  }

  Future<void> fetchOnlineFinancialData() async {
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

  Future<void> fetchOfflineFinancialData() async {
    final salesData = await dbHelper.getLocalSalesFinancialData();
    final purchaseData = await dbHelper.getLocalPurchaseFinancialData();

    final totalSalesInvoice =
        salesData.isEmpty ? 0 : salesData[0]['total_sales_invoice'];
    final totalPurchaseInvoice =
        purchaseData.isEmpty ? 0 : purchaseData[0]['total_purchase_invoice'];

    final totalSales = salesData.isEmpty
        ? 0
        : salesData.map((e) => e['total']).reduce((a, b) => a + b);

    final totalSalesReceived = salesData.isEmpty
        ? 0
        : salesData.map((e) => e['received']).reduce((a, b) => a + b) ?? 0;
    final totalDue = salesData.isEmpty
        ? 0
        : salesData.map((e) => e['due']).reduce((a, b) => a + b);
    final totalPurchase = purchaseData.isEmpty
        ? 0
        : purchaseData.map((e) => e['total']).reduce((a, b) => a + b);
    final totalPurchaseReceived = purchaseData.isEmpty
        ? 0
        : purchaseData.map((e) => e['received']).reduce((a, b) => a + b);

    if (kDebugMode) {
      print('Sales Data: $salesData');
      print('Purchase Data: $purchaseData');
    }

    final List<Map<String, dynamic>> generatedList = [];
    for (final sales in salesData) {
      final method = sales['method_mode'];
      bool isExist = false;
      for (final purchase in purchaseData) {
        if (purchase['method_mode'] == method) {
          generatedList.add(
            {
              'method_mode': method,
              'total': sales['received'] - purchase['received'],
            },
          );
          isExist = true;
        }
      }
      if (!isExist) {
        generatedList.add(
          {
            'method_mode': method,
            'total': sales['received'],
          },
        );
      }
    }
    if (kDebugMode) {
      print('generatedList $generatedList');
    }

    final data = {
      'total_sales_invoice': totalSalesInvoice,
      'total_purchase_invoice': totalPurchaseInvoice,
      'sales': totalSales?.toString() ?? '0',
      'due': totalDue?.toString() ?? '0',
      'purchase': totalPurchase?.toString() ?? '0',
      'receive_amount': totalSalesReceived?.toString() ?? '0',
      'payment_amount': totalPurchaseReceived?.toString() ?? '0',
      'expense_amount': '0',
      'balance_amount': (totalSalesReceived - totalPurchaseReceived).toString(),
      'transaction_overview': generatedList.map((e) {
        return {
          'name': e['method_mode'].toString(),
          'amount': e['total'].toString(),
        };
      }).toList(),
    };

    if (kDebugMode) {
      print('total sale $totalSales');
      print('total due $totalDue');
      print('total purchase $totalPurchase');
    }

    financialData.value = FinancialData.fromJson(
      data,
    );
  }

  Future<void> setSalesAndPurchaseOnline(bool value) async {
    isOnline.value = value;
    await prefs.setIsDashboardOnline(
      isDashboardOnline: value,
    );
    await prefs.setIsSalesOnline(
      isSalesOnline: value,
    );
    await prefs.setIsPurchaseOnline(
      isPurchaseOnline: value,
    );
    if (value) {
      await fetchOnlineFinancialData();
    } else {
      await fetchOfflineFinancialData();
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

  Future<void> showAddBrandModal() async {
    final data = await Get.dialog(
      DialogPattern(
        title: appLocalization.addBrand,
        subTitle: '',
        child: AddBrandModalView(),
      ),
    );
  }

  Future<void> showAddCategoryModal() async {
    final data = await Get.dialog(
      DialogPattern(
        title: appLocalization.addCategory,
        subTitle: '',
        child: AddCategoryModalView(),
      ),
    );
  }

  void goToSalesList() {
    if (!isRoleSales) {
      showSnackBar(
        type: SnackBarType.warning,
        title: appLocalization.alert,
        message: appLocalization.permissionDenied,
      );
      return;
    }

    Get.toNamed(
      Routes.salesList,
    );
  }

  void goToPurchaseList() {
    if (!isRolePurchase) {
      showSnackBar(
        type: SnackBarType.warning,
        title: appLocalization.alert,
        message: appLocalization.permissionDenied,
      );
      return;
    }

    Get.toNamed(
      Routes.purchaseList,
    );
  }

  void goToExpenseList() {
    if (!isRoleExpense) {
      showSnackBar(
        type: SnackBarType.warning,
        title: appLocalization.alert,
        message: appLocalization.permissionDenied,
      );
      return;
    }

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

  Future<void> onTapIsOnline(bool value) async {
    //isOnline.value = !isOnline.value;
    isOnline.value = value;
    update();
    await prefs.setIsDashboardOnline(
      isDashboardOnline: isOnline.value,
    );
    await prefs.setIsSalesOnline(
      isSalesOnline: isOnline.value,
    );
    await prefs.setIsPurchaseOnline(
      isPurchaseOnline: isOnline.value,
    );
    if (isOnline.value) {
      await fetchOnlineFinancialData();
    } else {
      await fetchOfflineFinancialData();
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

  Future<void> changeTheme({
    required String themeName,
  }) async {
    /// get theme from db
    final theme = await db.getAllWhr(
      tbl: dbTables.tableColorPlate,
      where: 'theme_name = ?',
      whereArgs: [themeName],
      limit: 1,
    );
    if (theme.isNotEmpty) {
      ColorSchema.fromJson(theme[0]);
      await prefs.setSelectedThemeName(
        themeName: themeName,
      );
      await Get.forceAppUpdate();
    }
  }

  Future<void> changeThemeMode() async {
    print('changeThemeMode: ${Get.isDarkMode}');
    Get.isDarkMode
        ? Get.changeThemeMode(ThemeMode.light)
        : Get.changeThemeMode(ThemeMode.dark);
    await Get.forceAppUpdate();
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
        list = await services.getBankList(
          methodId: item.id.toString(),
        );
      },
    );

    if (list != null) {
      await Get.dialog(
        DialogPattern(
          title: item.name ?? '',
          subTitle: '$currency  ${item.amount ?? ''}',
          child: list?.isEmpty ?? false
              ? Container()
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
                              '$currency ${bank.amount ?? ''}',
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

  Future<void> goToReportList() async {
    Get.toNamed(
      Routes.reportList,
    );
  }

  Future<void> updateApp() async {
    if (financialData.value?.updateUrl == null) {
      showSnackBar(
        message: appLocalization.somethingWentWrong,
        type: SnackBarType.error,
      );
      return;
    }
    final Uri url = Uri.parse(financialData.value!.updateUrl!);

    await url_launcher.launchUrl(url);
  }
}
