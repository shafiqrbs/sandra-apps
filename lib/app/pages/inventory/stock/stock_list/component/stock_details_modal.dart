import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/global_modal/add_product_modal/add_product_modal_view.dart';
import '/app/core/base/base_widget.dart';
import '/app/entity/stock.dart';
import 'package:nb_utils/nb_utils.dart';

import 'stock_card_view.dart';

class StockDetailsModal extends BaseWidget {
  final Stock element;
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
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              element.name ?? '',
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
                    label: appLocalization.qty,
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
                  child: labelValue,
                ),
                Expanded(
                  child: labelValue,
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
                  child: labelValue,
                ),
                Expanded(
                  child: labelValue,
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
                  child: labelValue,
                ),
                Expanded(
                  child: labelValue,
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
                  child: labelValue,
                ),
                Expanded(
                  child: labelValue,
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
                  child: labelValue,
                ),
                Expanded(
                  child: labelValue,
                ),
              ],
            ),
          ),
          12.height,
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _showEditStockDialog,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        containerBorderRadius,
                      ),
                      color: colors.solidBlueColor,
                    ),
                    margin: const EdgeInsets.only(
                      left: 4,
                    ),
                    child: Center(
                      child: Icon(
                        TablerIcons.pencil,
                        color: colors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: _deleteStock,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        containerBorderRadius,
                      ),
                      color: colors.solidRedColor,
                    ),
                    margin: const EdgeInsets.only(
                      left: 4,
                    ),
                    child: Center(
                      child: Icon(
                        TablerIcons.trash,
                        color: colors.primaryColor50,
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
        title: appLocalization.add,
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
