import 'package:get/get.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/entity/brand.dart';
import 'package:sandra/app/global_modal/add_brand_modal/add_brand_modal_view.dart';
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

  Future<void> onAddBrand() async {
    final data = await Get.dialog(
      DialogPattern(
        title: appLocalization.addBrand,
        subTitle: '',
        child: AddBrandModalView(),
      ),
    );
    if (data != null) {
      await onClearSearchText();
      await brandManager.paginate();
    }
  }
}
