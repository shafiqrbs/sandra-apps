import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/entity/brand.dart';
import 'package:sandra/app/entity/category.dart';
import 'package:sandra/app/entity/stock_details.dart';
import 'package:sandra/app/pages/inventory/stock/stock_list/component/stock_details_modal.dart';

import '/app/entity/stock.dart';
import '/app/global_modal/add_product_modal/add_product_modal_view.dart';

class StockListController extends BaseController {
  final isSearchSelected = false.obs;
  final isShowBrandClearIcon = false.obs;
  final isShowCategoryClearIcon = false.obs;
  final stockManager = StockManager();
  final brandManager = BrandManager();
  final categoryManager = CategoryManager();

  @override
  Future<void> onInit() async {
    super.onInit();
    await brandManager.getAll();
    await categoryManager.getAll();
    await stockManager.paginate();
  }

  Future<void> showAddStockModal() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.addProduct,
        subTitle: '',
        child: AddProductModalView(),
      ),
    );
    if (result != null) {
      if (kDebugMode) {
        print(result);
      }
    }
  }

  Future<void> onClearSearchText() async {
    stockManager.searchTextController.value.clear();
    stockManager.allItems.value?.clear();
    stockManager.allItems.refresh();
    isSearchSelected.toggle();
    await stockManager.paginate();
  }

  Future<void> refreshList() {
    stockManager.allItems.value?.clear();
    stockManager.allItems.refresh();
    return stockManager.paginate();
  }

  Future<void> showStockDetailsModal(Stock element) async {
    StockDetails? stockDetails;

    await dataFetcher(
      future: () async {
        stockDetails = await services.getStockDetails(
          id: element.itemId!,
        );
      },
    );
    if (stockDetails != null) {
      await Get.dialog(
        DialogPattern(
          title: stockDetails!.name!,
          subTitle:
              '${stockDetails!.remainingQuantity.toString()} ${stockDetails!.unitName}',
          subTitleStyle: AppTextStyle.h2TextStyle600,
          child: StockDetailsModal(
            element: stockDetails!,
          ),
        ),
      );
    }
  }

  void onBrandSelection(Brand? brand) {
    if (brand == null) {
      isShowBrandClearIcon.value = false;
    } else {
      isShowBrandClearIcon.value = true;
    }
    brandManager.ddController.value = brand;
  }

  void onCategorySelection(Category? category) {
    if (category == null) {
      isShowCategoryClearIcon.value = false;
    } else {
      isShowCategoryClearIcon.value = true;
    }
    categoryManager.ddController.value = category;
  }
}
