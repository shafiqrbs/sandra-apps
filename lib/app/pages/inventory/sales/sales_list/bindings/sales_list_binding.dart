import 'package:get/get.dart';
import '/app/pages/inventory/sales/sales_list/controllers/sales_list_controller.dart';

class SalesListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesListController>(
      () => SalesListController(),
      fenix: true,
    );
  }
}
  