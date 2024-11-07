import 'package:get/get.dart';
import '/app/pages/inventory/sales/sales_return_page/controllers/sales_return_page_controller.dart';

class SalesReturnPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesReturnPageController>(
      () => SalesReturnPageController(),
      fenix: true,
    );
  }
}
  