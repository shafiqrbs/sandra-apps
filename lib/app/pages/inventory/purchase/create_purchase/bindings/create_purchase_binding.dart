import 'package:get/get.dart';
import '/app/pages/inventory/purchase/create_purchase/controllers/create_purchase_controller.dart';

class CreatePurchaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePurchaseController>(
      CreatePurchaseController.new,
      fenix: true,
    );
  }
}
  