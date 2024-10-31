import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/entity/stock_details.dart';
import 'package:sandra/app/global_modal/add_product_modal/add_product_modal_view.dart';
import '/app/core/base/base_widget.dart';
import '/app/entity/stock.dart';
import 'package:nb_utils/nb_utils.dart';

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
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: spaceBetweenMAA,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        TablerIcons.tag,
                        size: 16,
                      ),
                      4.width,
                      Text(
                        element.name ?? '',
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
                        element.categoryName ?? 'N/A',
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
              left: 16,
              right: 16,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.purchasePrice,
                    value: element.purchasePrice.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.mrp,
                    value: element.salesPrice.toString(),
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
              left: 16,
              right: 16,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.avgPurchasePrice,
                    value: element.avgPurchasePrice,
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.avgMrp,
                    value: element.avgSalesPrice,
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
              left: 16,
              right: 16,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.purchaseQty,
                    value: element.purchaseQuantity.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
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
              left: 16,
              right: 16,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.openingQty,
                    value: element.openingQuantity.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
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
              left: 16,
              right: 16,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.purchaseReturnQty,
                    value: element.purchaseReturnQuantity.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
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
              left: 16,
              right: 16,
              top: 4,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.adjustQty,
                    value: element.adjustQuantity.toString(),
                  ),
                ),
                Expanded(
                  child: labelValue.copyWith(
                    label: appLocalization.bonusQty,
                    value: element.bonusQuantity.toString(),
                  ),
                ),
              ],
            ),
          ),
          12.height,
          Row(
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

  void _deleteStock() {}
}
