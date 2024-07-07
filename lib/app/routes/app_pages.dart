import 'package:get/get.dart';

import '/app/pages/customer_details/bindings/customer_details_binding.dart';
import '/app/pages/customer_details/views/customer_details_view.dart';
import '/app/pages/customer_list/bindings/customer_list_binding.dart';
import '/app/pages/customer_list/views/customer_list_view.dart';
import '/app/pages/dashboard/bindings/dashboard_binding.dart';
import '/app/pages/dashboard/views/dashboard_view.dart';

import '/app/pages/intro/license/bindings/license_binding.dart';
import '/app/pages/intro/license/views/license_view.dart';
import '/app/pages/intro/login/bindings/login_binding.dart';
import '/app/pages/intro/login/views/login_view.dart';
import '/app/pages/intro/splash/bindings/splash_binding.dart';
import '/app/pages/intro/splash/views/splash_view.dart';
import '/app/pages/inventory/sales/create_sales/bindings/create_sales_binding.dart';
import '/app/pages/inventory/sales/create_sales/views/create_sales_view.dart';
import '/app/pages/inventory/sales/sales_list/bindings/sales_list_binding.dart';
import '/app/pages/inventory/sales/sales_list/views/sales_list_view.dart';
import '/app/pages/stock_list/bindings/stock_list_binding.dart';
import '/app/pages/stock_list/views/stock_list_view.dart';

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
  ];
}
