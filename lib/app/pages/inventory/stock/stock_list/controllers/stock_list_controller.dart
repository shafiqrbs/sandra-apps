import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/entity/stock_details.dart';
import 'package:sandra/app/pages/inventory/stock/stock_list/component/stock_details_modal.dart';
import '/app/global_modal/add_product_modal/add_product_modal_view.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import '/app/entity/stock.dart';
import '/app/core/base/base_controller.dart';

class StockListController extends BaseController {
  final isSearchSelected = false.obs;
  final stockManager = StockManager();

  @override
  Future<void> onInit() async {
    super.onInit();
    await stockManager.paginate();
  }

  Future<void> showFilterModal({
    required BuildContext context,
  }) async {
    final value = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: appLocalization.stock,
          subTitle: appLocalization.advanceFilter,
          child: GlobalFilterModalView(),
        );
      },
    );

    if (value != null) {}
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
      print(result);
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
          subTitle: '${stockDetails!.remainingQuantity.toString()} ${stockDetails!.unitName}',
          subTitleStyle: AppTextStyle.h2TextStyle600,
          child: StockDetailsModal(
            element: stockDetails!,
          ),
        ),
      );
    }
  }
}
