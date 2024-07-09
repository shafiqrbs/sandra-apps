import 'package:get/get.dart';

import '/app/pages/accounting/customer_ledger/bindings/customer_ledger_binding.dart';
import '/app/pages/accounting/customer_ledger/views/customer_ledger_view.dart';
import '/app/pages/accounting/expense/bindings/expense_binding.dart';
import '/app/pages/accounting/expense/views/expense_view.dart';
import '/app/pages/accounting/vendor_ledger/bindings/vendor_ledger_binding.dart';
import '/app/pages/accounting/vendor_ledger/views/vendor_ledger_view.dart';
import '/app/pages/dashboard/bindings/dashboard_binding.dart';
import '/app/pages/dashboard/views/dashboard_view.dart';
import '/app/pages/domain/customer/customer_details/bindings/customer_details_binding.dart';
import '/app/pages/domain/customer/customer_details/views/customer_details_view.dart';
import '/app/pages/domain/customer/customer_list/bindings/customer_list_binding.dart';
import '/app/pages/domain/customer/customer_list/views/customer_list_view.dart';
import '/app/pages/domain/vendor/vendor_list/bindings/vendor_list_binding.dart';
import '/app/pages/domain/vendor/vendor_list/views/vendor_list_view.dart';
import '/app/pages/intro/license/bindings/license_binding.dart';
import '/app/pages/intro/license/views/license_view.dart';
import '/app/pages/intro/login/bindings/login_binding.dart';
import '/app/pages/intro/login/views/login_view.dart';
import '/app/pages/intro/splash/bindings/splash_binding.dart';
import '/app/pages/intro/splash/views/splash_view.dart';
import '/app/pages/inventory/purchase/create_purchase/bindings/create_purchase_binding.dart';
import '/app/pages/inventory/purchase/create_purchase/views/create_purchase_view.dart';
import '/app/pages/inventory/purchase/purchase_list/bindings/purchase_list_binding.dart';
import '/app/pages/inventory/purchase/purchase_list/views/purchase_list_view.dart';
import '/app/pages/inventory/sales/create_sales/bindings/create_sales_binding.dart';
import '/app/pages/inventory/sales/create_sales/views/create_sales_view.dart';
import '/app/pages/inventory/sales/sales_list/bindings/sales_list_binding.dart';
import '/app/pages/inventory/sales/sales_list/views/sales_list_view.dart';
import '/app/pages/inventory/stock/stock_list/bindings/stock_list_binding.dart';
import '/app/pages/inventory/stock/stock_list/views/stock_list_view.dart';
import '/app/pages/settings/bindings/settings_binding.dart';
import '/app/pages/settings/views/settings_view.dart';

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
      name: Routes.expense,
      page: ExpenseView.new,
      binding: ExpenseBinding(),
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
      name: Routes.vendorList,
      page: VendorListView.new,
      binding: VendorListBinding(),
    ),
    GetPage(
      name: Routes.purchaseList,
      page: PurchaseListView.new,
      binding: PurchaseListBinding(),
    ),
  ];
}
