import 'package:get/get.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/controllers/restaurant_home_controller.dart';

class RestaurantHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantHomeController>(
      RestaurantHomeController.new,
      fenix: true,
    );
  }
}
  