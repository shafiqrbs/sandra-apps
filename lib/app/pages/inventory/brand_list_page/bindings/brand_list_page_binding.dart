import 'package:get/get.dart';
import '/app/pages/inventory/brand_list_page/controllers/brand_list_page_controller.dart';

class BrandListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrandListPageController>(
      () => BrandListPageController(),
      fenix: true,
    );
  }
}
  