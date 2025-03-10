import 'package:get/get.dart';
import 'package:sandra/app/pages/intro/create_store/bindings/create_store_binding.dart';
import 'package:sandra/app/pages/intro/create_store/views/create_store_view.dart';
import 'package:sandra/app/pages/intro/onboarding/bindings/onboarding_binding.dart';
import 'package:sandra/app/pages/intro/onboarding/views/onboarding_view.dart';
import 'package:sandra/app/pages/inventory/sales/sales_return_list_page/sales_return_list_binding.dart';
import 'package:sandra/app/pages/inventory/sales/sales_return_list_page/sales_return_list_page.dart';
import 'package:sandra/app/pages/report/report_details/user_sales_overview_report/bindings/user_sales_overview_report_binding.dart';
import 'package:sandra/app/pages/report/report_details/user_sales_overview_report/views/user_sales_overview_report_view.dart';
import 'package:sandra/app/pages/report/report_list/bindings/report_list_binding.dart';
import 'package:sandra/app/pages/report/report_list/views/report_list_view.dart';

import '/app/pages/accounting/accounting_purchase/bindings/accounting_purchase_binding.dart';
import '/app/pages/accounting/accounting_purchase/views/accounting_purchase_view.dart';
import '/app/pages/accounting/accounting_sales/bindings/accounting_sales_binding.dart';
import '/app/pages/accounting/accounting_sales/views/accounting_sales_view.dart';
import '/app/pages/accounting/customer_ledger/bindings/customer_ledger_binding.dart';
import '/app/pages/accounting/customer_ledger/views/customer_ledger_view.dart';
import '/app/pages/accounting/expense/expense_list/bindings/expense_list_binding.dart';
import '/app/pages/accounting/expense/expense_list/views/expense_list_view.dart';
import '/app/pages/accounting/vendor_ledger/bindings/vendor_ledger_binding.dart';
import '/app/pages/accounting/vendor_ledger/views/vendor_ledger_view.dart';
import '/app/pages/content/account_config/bindings/account_config_binding.dart';
import '/app/pages/content/account_config/views/account_config_view.dart';
import '/app/pages/content/help_page/bindings/help_page_binding.dart';
import '/app/pages/content/help_page/views/help_page_view.dart';
import '/app/pages/content/privacy_config/bindings/privacy_config_binding.dart';
import '/app/pages/content/privacy_config/views/privacy_config_view.dart';
import '/app/pages/dashboard/bindings/dashboard_binding.dart';
import '/app/pages/dashboard/views/dashboard_view.dart';
import '/app/pages/domain/customer/customer_details/bindings/customer_details_binding.dart';
import '/app/pages/domain/customer/customer_details/views/customer_details_view.dart';
import '/app/pages/domain/customer/customer_list/bindings/customer_list_binding.dart';
import '/app/pages/domain/customer/customer_list/views/customer_list_view.dart';
import '/app/pages/domain/due_customer_list/bindings/due_customer_list_binding.dart';
import '/app/pages/domain/due_customer_list/views/due_customer_list_view.dart';
import '/app/pages/domain/user_list_page/bindings/user_list_page_binding.dart';
import '/app/pages/domain/user_list_page/views/user_list_page_view.dart';
import '/app/pages/domain/vendor/vendor_details/bindings/vendor_details_binding.dart';
import '/app/pages/domain/vendor/vendor_details/views/vendor_details_view.dart';
import '/app/pages/domain/vendor/vendor_list/bindings/vendor_list_binding.dart';
import '/app/pages/domain/vendor/vendor_list/views/vendor_list_view.dart';
import '/app/pages/intro/license/bindings/license_binding.dart';
import '/app/pages/intro/license/views/license_view.dart';
import '/app/pages/intro/login/bindings/login_binding.dart';
import '/app/pages/intro/login/views/login_view.dart';
import '/app/pages/intro/splash/bindings/splash_binding.dart';
import '/app/pages/intro/splash/views/splash_view.dart';
import '/app/pages/inventory/brand_list_page/bindings/brand_list_page_binding.dart';
import '/app/pages/inventory/brand_list_page/views/brand_list_page_view.dart';
import '/app/pages/inventory/category_list_page/bindings/category_list_page_binding.dart';
import '/app/pages/inventory/category_list_page/views/category_list_page_view.dart';
import '/app/pages/inventory/offline_sync_process/bindings/offline_sync_process_binding.dart';
import '/app/pages/inventory/offline_sync_process/views/offline_sync_process_view.dart';
import '/app/pages/inventory/particular/bindings/particular_binding.dart';
import '/app/pages/inventory/particular/views/particular_view.dart';
import '/app/pages/inventory/purchase/create_purchase/bindings/create_purchase_binding.dart';
import '/app/pages/inventory/purchase/create_purchase/views/create_purchase_view.dart';
import '/app/pages/inventory/purchase/purchase_list/bindings/purchase_list_binding.dart';
import '/app/pages/inventory/purchase/purchase_list/views/purchase_list_view.dart';
import '/app/pages/inventory/sales/create_sales/bindings/create_sales_binding.dart';
import '/app/pages/inventory/sales/create_sales/views/create_sales_view.dart';
import '/app/pages/inventory/sales/sales_list/bindings/sales_list_binding.dart';
import '/app/pages/inventory/sales/sales_list/views/sales_list_view.dart';
import '/app/pages/inventory/sales/sales_return_page/bindings/sales_return_page_binding.dart';
import '/app/pages/inventory/sales/sales_return_page/views/sales_return_page_view.dart';
import '/app/pages/inventory/stock/stock_list/bindings/stock_list_binding.dart';
import '/app/pages/inventory/stock/stock_list/views/stock_list_view.dart';
import '/app/pages/report/report_details/system_overview_report/bindings/system_overview_report_binding.dart';
import '/app/pages/report/report_details/system_overview_report/views/system_overview_report_view.dart';
import '/app/pages/restaurant_module/order_cart/bindings/order_cart_binding.dart';
import '/app/pages/restaurant_module/order_cart/views/order_cart_view.dart';
import '/app/pages/restaurant_module/restaurant_home/bindings/restaurant_home_binding.dart';
import '/app/pages/restaurant_module/restaurant_home/views/restaurant_home_view.dart';
import '/app/pages/settings/bindings/settings_binding.dart';
import '/app/pages/settings/views/settings_view.dart';
import '/app/pages/theme_test_page/bindings/theme_test_page_binding.dart';
import '/app/pages/theme_test_page/views/theme_test_page_view.dart';
import '/app/pages/view_demo/bindings/view_demo_binding.dart';
import '/app/pages/view_demo/views/view_demo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: SplashView.new,
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: OnboardingView.new,
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.createStore,
      page: CreateStoreView.new,
      binding: CreateStoreBinding(),
    ),
    GetPage(
      name: Routes.license,
      page: LicenseView.new,
      binding: LicenseBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: LoginView.new,
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: DashboardView.new,
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.customerList,
      page: CustomerListView.new,
      binding: CustomerListBinding(),
    ),
    GetPage(
      name: Routes.customerDetails,
      page: CustomerDetailsView.new,
      binding: CustomerDetailsBinding(),
    ),
    GetPage(
      name: Routes.stockList,
      page: StockListView.new,
      binding: StockListBinding(),
    ),
    GetPage(
      name: Routes.salesList,
      page: SalesListView.new,
      binding: SalesListBinding(),
    ),
    GetPage(
      name: Routes.createSales,
      page: CreateSalesView.new,
      binding: CreateSalesBinding(),
    ),
    GetPage(
      name: Routes.customerLedger,
      page: CustomerLedgerView.new,
      binding: CustomerLedgerBinding(),
    ),
    GetPage(
      name: Routes.vendorLedger,
      page: VendorLedgerView.new,
      binding: VendorLedgerBinding(),
    ),
    GetPage(
      name: Routes.createPurchase,
      page: CreatePurchaseView.new,
      binding: CreatePurchaseBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: SettingsView.new,
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.accountConfig,
      page: AccountConfigView.new,
      binding: AccountConfigBinding(),
    ),
    GetPage(
      name: Routes.privacyConfig,
      page: PrivacyConfigView.new,
      binding: PrivacyConfigBinding(),
    ),
    GetPage(
      name: Routes.vendorList,
      page: VendorListView.new,
      binding: VendorListBinding(),
    ),
    GetPage(
      name: Routes.purchaseList,
      page: PurchaseListView.new,
      binding: PurchaseListBinding(),
    ),
    GetPage(
      name: Routes.expenseList,
      page: ExpenseListView.new,
      binding: ExpenseListBinding(),
    ),
    GetPage(
      name: Routes.dueCustomerList,
      page: DueCustomerListView.new,
      binding: DueCustomerListBinding(),
    ),
    GetPage(
      name: Routes.particular,
      page: ParticularView.new,
      binding: ParticularBinding(),
    ),
    GetPage(
      name: Routes.vendorDetails,
      page: VendorDetailsView.new,
      binding: VendorDetailsBinding(),
    ),
    GetPage(
      name: Routes.accountingSales,
      page: AccountingSalesView.new,
      binding: AccountingSalesBinding(),
    ),
    GetPage(
      name: Routes.accountingPurchase,
      page: AccountingPurchaseView.new,
      binding: AccountingPurchaseBinding(),
    ),
    GetPage(
      name: Routes.themeTestPage,
      page: ThemeTestPageView.new,
      binding: ThemeTestPageBinding(),
    ),
    GetPage(
      name: Routes.restaurantHome,
      page: RestaurantHomeView.new,
      binding: RestaurantHomeBinding(),
    ),
    GetPage(
      name: Routes.orderCart,
      page: OrderCartView.new,
      binding: OrderCartBinding(),
    ),
    GetPage(
      name: Routes.helpPage,
      page: HelpPageView.new,
      binding: HelpPageBinding(),
    ),
    GetPage(
      name: Routes.offlineSyncProcess,
      page: OfflineSyncProcessView.new,
      binding: OfflineSyncProcessBinding(),
    ),
    GetPage(
      name: Routes.brandListPage,
      page: BrandListPageView.new,
      binding: BrandListPageBinding(),
    ),
    GetPage(
      name: Routes.categoryListPage,
      page: CategoryListPageView.new,
      binding: CategoryListPageBinding(),
    ),
    GetPage(
      name: Routes.userListPage,
      page: UserListPageView.new,
      binding: UserListPageBinding(),
    ),
    GetPage(
      name: Routes.salesReturnPage,
      page: SalesReturnPageView.new,
      binding: SalesReturnPageBinding(),
    ),
    GetPage(
      name: Routes.reportList,
      page: ReportListView.new,
      binding: ReportListBinding(),
    ),
    GetPage(
      name: Routes.systemOverviewReport,
      page: SystemOverviewReportView.new,
      binding: SystemOverviewReportBinding(),
    ),
    GetPage(
      name: Routes.userSalesOverviewReport,
      page: UserSalesOverviewReportView.new,
      binding: UserSalesOverviewReportBinding(),
    ),
    GetPage(
      name: Routes.salesReturnListPage,
      page: SalesReturnListPage.new,
      binding: SalesReturnListBinding(),
    ),
    GetPage(
      name: Routes.viewDemo,
      page: () => ViewDemoView(),
      binding: ViewDemoBinding(),
    ),
  ].obs;
}
