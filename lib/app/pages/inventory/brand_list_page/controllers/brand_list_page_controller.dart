import 'package:get/get.dart';
import 'package:sandra/app/entity/brand.dart';
import '/app/core/base/base_controller.dart';

class BrandListPageController extends BaseController {
  final brandManager = BrandManager();
  final isSearchSelected = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await brandManager.paginate();
  }

  Future<void> onClearSearchText() async {
    brandManager.searchTextController.value.clear();
    brandManager.allItems.value?.clear();
    brandManager.allItems.refresh();
    isSearchSelected.value = false;
    await brandManager.paginate();
  }
}
