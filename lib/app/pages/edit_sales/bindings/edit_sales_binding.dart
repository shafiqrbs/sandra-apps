import 'package:get/get.dart';
import '/app/pages/edit_sales/controllers/edit_sales_controller.dart';

class EditSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditSalesController>(
      () => EditSalesController(),
      fenix: true,
    );
  }
}
  