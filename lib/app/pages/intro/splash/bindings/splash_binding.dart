import 'package:get/get.dart';
import '/app/pages/intro/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      SplashController.new,
      fenix: true,
    );
  }
}

  