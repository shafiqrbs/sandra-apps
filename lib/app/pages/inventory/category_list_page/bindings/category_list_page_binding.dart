import 'package:get/get.dart';

import '/app/pages/inventory/category_list_page/controllers/category_list_page_controller.dart';

class CategoryListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryListPageController>(
      CategoryListPageController.new,
      fenix: true,
    );
  }
}
