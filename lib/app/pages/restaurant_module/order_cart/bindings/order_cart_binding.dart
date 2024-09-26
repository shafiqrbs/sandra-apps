import 'package:get/get.dart';
import 'package:sandra/app/pages/restaurant_module/order_cart/controllers/order_cart_controller.dart';

class OrderCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderCartController>(
      OrderCartController.new,
      fenix: true,
    );
  }
}
  