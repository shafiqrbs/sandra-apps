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
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final brand = args['brand'] as Brand?;
      if (brand != null) {
        brandManager.ddController.value =
            brandManager.allItems.value?.firstWhereOrNull(
          (element) => element.brandId == brand.brandId,
        );
        isShowBrandClearIcon.value = true;
      }
      final category = args['category'] as Category?;
      if (category != null) {
        categoryManager.ddController.value =
            categoryManager.allItems.value?.firstWhereOrNull(
          (element) => element.categoryId == category.categoryId,
        );
        isShowCategoryClearIcon.value = true;
      }
    }
    await getStockList(null);
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
    isSearchSelected.toggle();
    await getStockList(null);
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

  Future<void> onBrandSelection(Brand? brand) async {
    if (brand == null) {
      isShowBrandClearIcon.value = false;
    } else {
      isShowBrandClearIcon.value = true;
    }
    brandManager.ddController.value = brand;
    await getStockList(null);
  }

  Future<void> onCategorySelection(Category? category) async {
    if (category == null) {
      isShowCategoryClearIcon.value = false;
    } else {
      isShowCategoryClearIcon.value = true;
    }
    categoryManager.ddController.value = category;
    await getStockList(null);
  }

  Future<void> getStockList(String? temp) async {
    final brand = brandManager.ddController.value;
    final category = categoryManager.ddController.value;
    final search = stockManager.searchTextController.value.text;

    // Helper function to clear and refresh the items
    void clearAndRefreshItems() {
      stockManager.allItems.value?.clear();
      stockManager.allItems.refresh();
    }

    // Clear items and paginate if no filters are applied
    if (brand == null && category == null && search.isEmpty) {
      clearAndRefreshItems();
      await stockManager.paginate();
      return;
    }

    // Build query dynamically based on selected filters
    final List<String> whereClauses = [];
    final List<String> whereArgs = [];

    if (search.isNotEmpty) {
      whereClauses.add('name LIKE ?');
      whereArgs.add('%$search%');
    }

    if (brand != null) {
      whereClauses.add('brand_name = ?');
      whereArgs.add(brand.name!);
    }

    if (category != null) {
      whereClauses.add('category_name = ?');
      whereArgs.add(category.name!);
    }

    final query = whereClauses.join(' AND ');

    // if it's a only search query, limit the results to 100
    final limit =
        search.isNotEmpty && brand == null && category == null ? 100 : null;

    // Fetch filtered data from the database
    final data = await db.getAllWhr(
      tbl: DbTables().tableStocks,
      where: query,
      whereArgs: whereArgs,
      limit: limit,
    );

    clearAndRefreshItems();

    // Update the stock manager's items if data is not empty
    if (data.isNotEmpty) {
      stockManager.allItems.value = data.map((e) => Stock.fromJson(e)).toList();
      stockManager.allItems.refresh();
    }
  }
}
