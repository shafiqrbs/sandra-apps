import 'package:get/get.dart';
import '/app/pages/create_sales/controllers/create_sales_controller.dart';

class CreateSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSalesController>(
      () => CreateSalesController(),
      fenix: true,
    );
  }
}
  