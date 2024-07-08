import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/model/purchase_item.dart';
import '/app/core/base/base_widget.dart';
import '/app/core/core_model/setup.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/utils/style_function.dart';
import '/app/model/sales_item.dart';
import 'package:nb_utils/nb_utils.dart';

class PurchaseItemListView extends BaseWidget {
  final List<PurchaseItem> salesItems;
  final Function(int index) onItemRemove;
  final Function(num onQtyChange, int index) onQtyChange;
  final Function(num onQtyChange, int index) onDiscountChange;
  final Function(num onSalesPriceChange, int index) onSalesPriceChange;
  PurchaseItemListView({
    required this.salesItems,
    required this.onItemRemove,
    required this.onQtyChange,
    required this.onDiscountChange,
    required this.onSalesPriceChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorSchema();
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: salesItems.length,
      padding: const EdgeInsets.only(
        bottom: 60,
      ),
      itemBuilder: (context, index) {
        final element = salesItems[index];
        final currency = SetUp().currency ?? '';
        final canEditPrice = false;
        final mrpController = TextEditingController();
        final qtyController = TextEditingController();
        final subtotalController = TextEditingController();

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              //  height: 100,
              color: index.isEven ? colors.evenListColor : colors.oddListColor,
              margin: const EdgeInsets.only(bottom: 4, left: 16, right: 2),
              padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Text(
                          element.stockName ?? '',
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: spaceBetweenMAA,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              element.brandName ?? '',
                              textAlign: TextAlign.left,
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'In Stock: ${element.quantity}' ?? '',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'PP: ${element.price}' ?? '',
                            ),
                          ),
                        ],
                      ),
                      8.height,
                      Row(
                        mainAxisAlignment: spaceBetweenMAA,
                        children: [
                          //product MRP
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.zero,
                                  height: mediumTextFieldHeight,
                                  alignment: Alignment.center,
                                  //width: Get.width * 0.7,
                                  color: Colors.transparent,
                                  child: TextFormField(
                                    controller: mrpController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [regexDouble],
                                    textInputAction: TextInputAction.next,
                                    readOnly: canEditPrice,
                                    onEditingComplete: () {},
                                    style: TextStyle(
                                      fontSize: mediumTFSize,
                                      color: colors.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText:
                                          'price'.tr, // Optional hint text
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          containerBorderRadius,
                                        ),
                                        borderSide: BorderSide(
                                          color: index.isEven
                                              ? colors.evenListColor
                                              : colors.oddListColor,
                                          width: 0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          containerBorderRadius,
                                        ),
                                        borderSide: BorderSide(
                                          color: index.isEven
                                              ? colors.evenListColor
                                              : colors.oddListColor,
                                          width: 0,
                                        ),
                                      ),
                                      fillColor: index.isEven
                                          ? colors.primaryLiteColor
                                              .withOpacity(.2)
                                          : colors.primaryLiteColor
                                              .withOpacity(.2),
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          4.width,
                          // Quantity
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  height: mediumTextFieldHeight,
                                  //width: Get.width * 0.7,
                                  color: colors.textFieldColor,
                                  child: TextFormField(
                                    controller: qtyController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [regexDouble],
                                    textInputAction: doneInputAction,
                                    onChanged: (value) {
                                      onQtyChange(
                                        value.toDouble(),
                                        index,
                                      );
                                    },
                                    onEditingComplete: () {
                                      //close keyboard
                                      FocusScope.of(context).unfocus();
                                    },
                                    style: TextStyle(
                                      fontSize: mediumTFSize,
                                      color: colors.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: getInputDecoration(
                                      hint: 'qty'.tr,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          4.width,

                          // sub total price
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.zero,
                                  padding: const EdgeInsets.only(
                                    left: 2,
                                    right: 2,
                                  ),
                                  height: mediumTextFieldHeight,
                                  alignment: Alignment.center,
                                  //width: Get.width * 0.7,
                                  color: Colors.transparent,
                                  child: TextFormField(
                                    controller: subtotalController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [regexDouble],
                                    textInputAction: TextInputAction.next,
                                    readOnly: true,
                                    onEditingComplete: () {},
                                    style: TextStyle(
                                      fontSize: mediumTFSize,
                                      color: colors.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText:
                                          'sub_total'.tr, // Optional hint text
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          containerBorderRadius,
                                        ),
                                        borderSide: BorderSide(
                                          color: index.isEven
                                              ? colors.evenListColor
                                              : colors.oddListColor,
                                          width: 0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          containerBorderRadius,
                                        ),
                                        borderSide: BorderSide(
                                          color: index.isEven
                                              ? colors.evenListColor
                                              : colors.oddListColor,
                                          width: 0,
                                        ),
                                      ),
                                      fillColor: index.isEven
                                          ? colors.primaryLiteColor
                                              .withOpacity(.2)
                                          : colors.primaryLiteColor
                                              .withOpacity(.2),
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          4.width,
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: -20,
                    top: -8,
                    child: TextButton(
                      onPressed: () async {
                        onItemRemove(index);
                        //mvc.salesSubTotal.value -= mvc.salesItemList[index].subTotal!;
                        //mvc.salesItemList.removeAt(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.dangerLiteColor,
                        ),
                        child: Icon(
                          TablerIcons.x,
                          size: 18,
                          color: colors.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 2,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 4,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: index.isEven
                        ? colors.evenListColor
                        : colors.oddListColor,
                  ),
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
