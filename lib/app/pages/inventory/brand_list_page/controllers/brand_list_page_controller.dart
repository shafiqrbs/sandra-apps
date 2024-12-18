import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/entity/brand.dart';
import 'package:sandra/app/global_modal/add_brand_modal/add_brand_modal_view.dart';

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

  void onBrandTap(Brand element) {
    while (Get.currentRoute != Routes.dashboard) {
      Get.back();
    }
    Get.toNamed(Routes.stockList, arguments: {'brand': element});
  }

  Future<void> editBrand(Brand element) async {
    final data = await Get.dialog(
      DialogPattern(
        title: appLocalization.edit,
        subTitle: '',
        child: AddBrandModalView(),
      ),
      arguments: {
        'brand': element,
      },
    );
    if (data != null && data is Brand) {
      await onClearSearchText();
      await brandManager.paginate();
    }
  }
}
