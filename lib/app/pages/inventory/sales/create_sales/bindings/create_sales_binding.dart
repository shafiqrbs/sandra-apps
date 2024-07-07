import 'package:get/get.dart';
import '../controllers/create_sales_controller.dart';

class CreateSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSalesController>(
      CreateSalesController.new,
      fenix: true,
    );
  }
}
