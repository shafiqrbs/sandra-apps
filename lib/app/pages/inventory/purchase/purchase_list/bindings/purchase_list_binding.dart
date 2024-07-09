import 'package:get/get.dart';
import '/app/pages/inventory/purchase/purchase_list/controllers/purchase_list_controller.dart';

class PurchaseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseListController>(
      PurchaseListController.new,
      fenix: true,
    );
  }
}
