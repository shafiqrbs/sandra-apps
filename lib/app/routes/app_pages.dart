import 'package:get/get.dart';
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
  ];
}
