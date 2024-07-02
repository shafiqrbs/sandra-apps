import 'package:get/get.dart';

import '/app/pages/create_sales/bindings/create_sales_binding.dart';
import '/app/pages/create_sales/views/create_sales_view.dart';
import '/app/pages/customer_details/bindings/customer_details_binding.dart';
import '/app/pages/customer_details/views/customer_details_view.dart';
import '/app/pages/dashboard/bindings/dashboard_binding.dart';
import '/app/pages/dashboard/views/dashboard_view.dart';
import '/app/pages/license/bindings/license_binding.dart';
import '/app/pages/license/views/license_view.dart';
import '/app/pages/login/bindings/login_binding.dart';
import '/app/pages/login/views/login_view.dart';
import '/app/pages/splash/bindings/splash_binding.dart';
import '/app/pages/splash/views/splash_view.dart';

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
      name: Routes.createSales,
      page: CreateSalesView.new,
      binding: CreateSalesBinding(),
    ),
    GetPage(
      name: Routes.customerDetails,
      page: CustomerDetailsView.new,
      binding: CustomerDetailsBinding(),
    ),
  ];
}
