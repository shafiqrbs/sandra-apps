import 'package:get/get.dart';
import '/app/pages/stock_list/controllers/stock_list_controller.dart';

class StockListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockListController>(
      () => StockListController(),
      fenix: true,
    );
  }
}
  