import 'package:get/get.dart';
import '/app/pages/customer_list/controllers/customer_list_controller.dart';

class CustomerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerListController>(
      () => CustomerListController(),
      fenix: true,
    );
  }
}
  