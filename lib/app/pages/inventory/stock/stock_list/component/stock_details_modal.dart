import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/entity/stock_details.dart';
import 'package:sandra/app/global_modal/add_product_modal/add_product_modal_view.dart';

import '/app/core/base/base_widget.dart';
import '../controllers/stock_list_controller.dart';
import 'stock_card_view.dart';

class StockDetailsModal extends BaseWidget {
  final StockDetails element;

  StockDetailsModal({
    required this.element,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: startMAA,
        crossAxisAlignment: startCAA,
        children: [
          12.height,
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: Row(
              mainAxisAlignment: spaceBetweenMAA,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: startCAA,
                    children: [
                      const Icon(
                        TablerIcons.tag,
                        size: 16,
                      ),
                      4.width,
                      Expanded(
                        child: Text(
                          element.brandName ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                8.width,
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        TablerIcons.category,
                        size: 16,
                      ),
                      4.width,
                      Text(
                        (element.categoryName == null ||
                                    element.categoryName!.isEmpty
                                ? 'N/A'
                                : element.categoryName) ??
                            'N/A',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          12.height,
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF6F1F7),
            ),
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.purchasePrice,
                    value: isRoleManager
                        ? '${SetUp().symbol ?? ''} ${element.purchasePrice.toString()}'
                        : '',
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.mrp,
                    value:
                        '${SetUp().symbol ?? ''} ${element.salesPrice.toString()}',
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.avgPurchasePrice,
                    value: isRoleManager
                        ? '${SetUp().symbol ?? ''} ${element.avgPurchasePrice}'
                        : '',
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.avgMrp,
                    value: '${SetUp().symbol ?? ''} ${element.avgSalesPrice}',
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF6F1F7),
            ),
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.purchaseQty,
                    value: element.purchaseQuantity.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.salesQty,
                    value: element.salesQuantity.toString(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.openingQty,
                    value: element.openingQuantity.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.damageQuantity,
                    value: element.damageQuantity.toString(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF6F1F7),
            ),
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.purchaseReturnQty,
                    value: element.purchaseReturnQuantity.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.salesReturnQty,
                    value: element.salesReturnQuantity.toString(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.adjustQty,
                    value: element.adjustQuantity.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    labelFlex: 4,
                    valueFlex: 3,
                    label: appLocalization.bonusQty,
                    value: element.bonusQuantity.toString(),
                  ),
                ),
              ],
            ),
          ),
          12.height,
          Visibility(
            visible: isRoleManager,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _deleteStock,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: colors.secondaryRedColor,
                      ),
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: centerMAA,
                          children: [
                            Icon(
                              TablerIcons.trash,
                              color: colors.solidBlackColor,
                              size: 18,
                            ),
                            4.width,
                            Text(
                              appLocalization.remove,
                              style: AppTextStyle.h3TextStyle500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: _showEditStockDialog,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: colors.secondaryGreenColor,
                      ),
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: centerMAA,
                          children: [
                            Icon(
                              TablerIcons.pencil,
                              color: colors.solidBlackColor,
                              size: 18,
                            ),
                            4.width,
                            Text(
                              appLocalization.edit,
                              style: AppTextStyle.h3TextStyle500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.height,
        ],
      ),
    );
  }

  void _showEditStockDialog() {
    Get.dialog(
      DialogPattern(
        title: appLocalization.updateProduct,
        subTitle: '',
        child: AddProductModalView(),
      ),
      arguments: {
        'stock': element,
      },
    );
  }

  Future<void> _deleteStock() async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      final controller = Get.find<HelperController>();
      bool? isDeleted;
      await controller.dataFetcher(
        future: () async {
          isDeleted = await controller.services.deleteStock(
            id: element.id.toString(),
          );
        },
      );
      if (isDeleted ?? false) {
        await dbHelper.deleteAllWhr(
          tbl: dbTables.tableStocks,
          where: 'item_id = ?',
          whereArgs: [element.id],
        );
        final stockListController = Get.find<StockListController>();
        await stockListController.refreshList();
        Get.back();
      }
    }
  }
}
