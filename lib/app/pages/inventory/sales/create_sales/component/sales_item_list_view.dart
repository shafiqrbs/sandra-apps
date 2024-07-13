import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/base/base_widget.dart';
import '/app/core/core_model/setup.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/utils/style_function.dart';
import '/app/entity/sales_item.dart';
import 'package:nb_utils/nb_utils.dart';

class SalesItemListView extends BaseWidget {
  final List<SalesItem> salesItems;
  final Function(int index) onItemRemove;
  final Function(num onQtyChange, int index) onQtyChange;
  final Function(num onQtyChange, int index) onDiscountChange;
  final Function(num onSalesPriceChange, int index) onSalesPriceChange;
  SalesItemListView({
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

        final mrpController = TextEditingController(
          text:
              '${SetUp().currency ?? ''} ${element.mrpPrice?.toString() ?? '0.00'}',
        );

        final salesItemSalesPriceController = TextEditingController(
          text: element.salesPrice == null
              ? '0.00'
              : element.salesPrice.toString(),
        ).obs;
        final salesItemQtyController = TextEditingController(
          text: element.quantity == null ? '' : element.quantity.toString(),
        ).obs;
        final salesItemDiscountPercentController = TextEditingController(
          text: element.discountPercent == null
              ? ''
              : element.discountPercent.toString(),
        ).obs;
        final salesItemSubTotalController = TextEditingController(
          text: element.subTotal == null
              ? SetUp().currency ?? ''
              : '${SetUp().currency ?? ''} ${element.subTotal}',
        ).obs;

        final canEditSalesItemPrice =
            (salesItemDiscountPercentController.value.text.toDouble() > 0).obs;

        final canEditSalesItemDiscountPercent =
            (element.salesPrice != element.mrpPrice &&
                    (salesItemDiscountPercentController.value.text.toDouble() ==
                            0 ||
                        salesItemDiscountPercentController
                            .value.text.isEmptyOrNull))
                .obs;

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
                              'PP: ${element.purchasePrice}' ?? '',
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
                                  height:mediumTextFieldHeight,
                                  alignment: Alignment.center,
                                  //width: Get.width * 0.7,
                                  color: Colors.transparent,
                                  child: TextFormField(
                                    controller: mrpController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [regexDouble],
                                    textInputAction: TextInputAction.next,
                                    readOnly: true,
                                    onEditingComplete: () {},
                                    style: TextStyle(
                                      fontSize:mediumTFSize,
                                      color: colors.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: 'mrp'.tr, // Optional hint text
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
                          // discount price
                          Expanded(
                            flex: 2,
                            child: Obx(
                              () => Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                height:mediumTextFieldHeight,
                                //width: Get.width * 0.7,
                                color: colors.textFieldColor,
                                child: TextFormField(
                                  controller:
                                      salesItemDiscountPercentController.value,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [regexDouble],
                                  textInputAction: TextInputAction.next,
                                  readOnly:
                                      canEditSalesItemDiscountPercent.value,
                                  onChanged: (value) {
                                    if (value.isEmptyOrNull) {
                                      value = '0';
                                    }
                                    onDiscountChange(
                                      value.toInt(),
                                      index,
                                    );
                                    final salesPrice = (element.mrpPrice! -
                                            (element.mrpPrice! *
                                                    value.toDouble()) /
                                                100)
                                        .toPrecision(2);
                                    final subTotal =
                                        (salesPrice * element.quantity!)
                                            .toPrecision(2);
                                    final discountPercent = value.toDouble();
                                    salesItemSalesPriceController.value.text =
                                        salesPrice.toString();
                                    salesItemSubTotalController.value.text =
                                        subTotal.toString();
                                    canEditSalesItemPrice.value =
                                        element.discountPercent! > 0;
                                  },
                                  style: TextStyle(
                                    fontSize:mediumTFSize,
                                    color: colors.primaryTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  cursorColor: colors.formCursorColor,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ), // Adjust the padding as needed
                                    hintText: '%', // Optional hint text
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                       containerBorderRadius,
                                      ),
                                      borderSide: BorderSide(
                                        color: colors.borderColor,
                                        width: 0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                       containerBorderRadius,
                                      ),
                                      borderSide: BorderSide(
                                        color: colors.borderColor,
                                        width: 0,
                                      ),
                                    ),
                                    fillColor: colors.textFieldColor,
                                    filled:
                                        canEditSalesItemDiscountPercent.value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          4.width,
                          // discount
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                // product discount price
                                Expanded(
                                  flex: 2,
                                  child: Obx(
                                    () => Container(
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.zero,
                                      height:mediumTextFieldHeight,
                                      //width: Get.width * 0.7,
                                      color: colors.textFieldColor,
                                      child: TextFormField(
                                        controller:
                                            salesItemSalesPriceController.value,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [regexDouble],
                                        textInputAction: TextInputAction.next,
                                        readOnly: canEditSalesItemPrice.value,
                                        //readOnly: true,
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            value = element.mrpPrice.toString();
                                          }

                                          onSalesPriceChange(
                                            value.toDouble(),
                                            index,
                                          );

                                          salesItemSubTotalController
                                                  .value.text =
                                              element.subTotal.toString();
                                          salesItemSalesPriceController
                                              .value.text = value;
                                          salesItemSalesPriceController
                                                  .value.selection =
                                              TextSelection.fromPosition(
                                            TextPosition(
                                              offset:
                                                  salesItemSalesPriceController
                                                      .value.text.length,
                                            ),
                                          );
                                          canEditSalesItemDiscountPercent
                                              .value = element.salesPrice !=
                                                  element.mrpPrice &&
                                              element.discountPercent == 0;
                                        },

                                        style: TextStyle(
                                          fontSize:mediumTFSize,
                                          color: colors.primaryTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),

                                        decoration: getInputDecoration(
                                          hint: 'price'.tr,
                                        ),
                                      ),
                                    ),
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
                                        height:
                                           mediumTextFieldHeight,
                                        //width: Get.width * 0.7,
                                        color: colors.textFieldColor,
                                        child: TextFormField(
                                          controller:
                                              salesItemQtyController.value,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [regexDouble],
                                          textInputAction: doneInputAction,
                                          onChanged: (value) {
                                            onQtyChange(
                                              value.toDouble(),
                                              index,
                                            );
                                            salesItemSubTotalController
                                                    .value.text =
                                                element.subTotal.toString();
                                            salesItemSubTotalController
                                                    .value.selection =
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                offset:
                                                    salesItemSubTotalController
                                                        .value.text.length,
                                              ),
                                            );
                                            if (kDebugMode) {
                                              print(
                                                'salesItemQtyController.value.text: ${salesItemQtyController.value.text}',
                                              );
                                              print(
                                                'salesItemSubTotalController.value.text: ${salesItemSubTotalController.value.text}',
                                              );
                                            }
                                          },
                                          onEditingComplete: () {
                                            //close keyboard
                                            FocusScope.of(context).unfocus();
                                          },
                                          style: TextStyle(
                                            fontSize:mediumTFSize,
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
                                  height:mediumTextFieldHeight,
                                  alignment: Alignment.center,
                                  //width: Get.width * 0.7,
                                  color: Colors.transparent,
                                  child: TextFormField(
                                    controller:
                                        salesItemSubTotalController.value,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [regexDouble],
                                    textInputAction: TextInputAction.next,
                                    readOnly: true,
                                    onEditingComplete: () {},
                                    style: TextStyle(
                                      fontSize:mediumTFSize,
                                      color: colors.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText:
                                          appLocalization.subTotal, // Optional hint text
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
