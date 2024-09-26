import 'package:get/get.dart';
import '/app/pages/domain/due_customer_list/controllers/due_customer_list_controller.dart';

class DueCustomerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DueCustomerListController>(
      DueCustomerListController.new,
      fenix: true,
    );
  }
}
