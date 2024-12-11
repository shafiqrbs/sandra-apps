import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/common_header_text.dart';

import '/app/core/base/base_widget.dart';
import '/app/core/core_model/setup.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/utils/style_function.dart';
import '/app/entity/purchase_item.dart';

class PurchaseItemListView extends StatelessWidget {
  final List<PurchaseItem> salesItems;
  final Function(int index) onItemRemove;
  final Function(num onQtyChange, int index) onQtyChange;
  final Function(num onQtyChange, int index) onPriceChange;

  PurchaseItemListView({
    required this.salesItems,
    required this.onItemRemove,
    required this.onQtyChange,
    required this.onPriceChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorSchema();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 32, right: 8),
          decoration: BoxDecoration(
            color: colors.primaryColor300,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonHeaderText(
                flex: 2,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                header: appLocalization.quantity,
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    CommonHeaderText(
                      flex: 2,
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      header: appLocalization.price,
                    ),
                  ],
                ),
              ),
              CommonHeaderText(
                flex: 2,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 8),
                margin: EdgeInsets.zero,
                header: appLocalization.total,
              ),
            ],
          ),
        ),
        4.height,
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: salesItems.length,
            padding: const EdgeInsets.only(
              bottom: 30,
            ),
            itemBuilder: (context, index) {
              final element = salesItems[index];
              final priceController = TextEditingController(
                text: element.price.toString(),
              );
              final qtyController = TextEditingController(
                text: element.quantity.toString(),
              );
              final subtotalController = TextEditingController(
                text: element.subTotal.toString(),
              );

              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    //  height: 100,
                    color: index.isEven
                        ? colors.secondaryColor50
                        : colors.primaryColor50,
                    margin:
                        const EdgeInsets.only(bottom: 4, left: 16, right: 2),
                    padding:
                        const EdgeInsets.only(left: 16, right: 8, bottom: 4),
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
                                //product Price
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.zero,
                                        height: mediumTextFieldHeight,
                                        color: colors.whiteColor,
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
                                            setSubTotal(
                                              qtyController,
                                              priceController,
                                              subtotalController,
                                            );
                                          },
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                          onTap: qtyController.clear,
                                          style: TextStyle(
                                            fontSize: mediumTFSize,
                                            color: colors.solidBlackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: getInputDecoration(
                                            hint: appLocalization.qty,
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
                                        color: colors.whiteColor,
                                        child: TextFormField(
                                          controller: priceController,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [regexDouble],
                                          textInputAction: doneInputAction,
                                          onEditingComplete: () {
                                            //close keyboard
                                            FocusScope.of(context).unfocus();
                                          },
                                          style: TextStyle(
                                            fontSize: mediumTFSize,
                                            color: colors.solidBlackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: getInputDecoration(
                                            hint: appLocalization.price,
                                          ),
                                          onChanged: (value) {
                                            onPriceChange(
                                              value.toDouble(),
                                              index,
                                            );
                                            setSubTotal(
                                              qtyController,
                                              priceController,
                                              subtotalController,
                                            );
                                          },
                                          onTap: priceController.clear,
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
                                            color: colors.solidBlackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            hintText: appLocalization.subTotal,
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                containerBorderRadius,
                                              ),
                                              borderSide: BorderSide(
                                                color: index.isEven
                                                    ? colors.secondaryColor50
                                                    : colors.primaryColor50,
                                                width: 0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                containerBorderRadius,
                                              ),
                                              borderSide: BorderSide(
                                                color: index.isEven
                                                    ? colors.secondaryColor50
                                                    : colors.primaryColor50,
                                                width: 0,
                                              ),
                                            ),
                                            fillColor: colors.primaryColor100,
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
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  containerBorderRadius,
                                ),
                                color: colors.primaryRedColor,
                              ),
                              child: Icon(
                                TablerIcons.x,
                                size: 18,
                                color: colors.whiteColor,
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
                              ? colors.secondaryColor50
                              : colors.primaryColor50,
                        ),
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.solidBlackColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void setSubTotal(
    TextEditingController qtyController,
    TextEditingController priceController,
    TextEditingController subtotalController,
  ) {
    final qty = double.tryParse(qtyController.text) ?? 0.0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    subtotalController.text = (qty * price).toStringAsFixed(2);
  }
}
