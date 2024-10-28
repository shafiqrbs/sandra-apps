import 'package:get/get.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/entity/category.dart';
import 'package:sandra/app/global_modal/add_category_modal/add_category_modal_view.dart';
import '/app/core/base/base_controller.dart';

class CategoryListPageController extends BaseController {
  final categoryManager = CategoryManager();
  final isSearchSelected = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await categoryManager.paginate();
  }

  Future<void> onClearSearchText() async {
    categoryManager.searchTextController.value.clear();
    categoryManager.allItems.value?.clear();
    categoryManager.allItems.refresh();
    isSearchSelected.value = false;
    await categoryManager.paginate();
  }

  Future<void> onAddCategory() async {
    final data = await Get.dialog(
      DialogPattern(
        title: appLocalization.addCategory,
        subTitle: '',
        child: AddCategoryModalView(),
      ),
    );
    if (data != null) {
      await onClearSearchText();
      await categoryManager.paginate();
    }
  }
}
