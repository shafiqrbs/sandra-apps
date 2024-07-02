import 'package:get/get.dart';
import '/app/pages/customer_details/controllers/customer_details_controller.dart';

class CustomerDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerDetailsController>(
      () => CustomerDetailsController(),
      fenix: true,
    );
  }
}
  