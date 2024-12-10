import 'package:get/get.dart';

import 'sales_return_list_controller.dart';

class SalesReturnListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesReturnListController>(
      SalesReturnListController.new,
      fenix: true,
    );
  }
}
