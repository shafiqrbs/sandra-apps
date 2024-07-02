import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/pages/create_sales/component/sales_item_list_view.dart';
import 'package:getx_template/app/pages/create_sales/component/searched_stock_list.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/selected_stock_list_header.dart';
import '/app/global_widget/product_search_form.dart';
import '/app/pages/create_sales/controllers/create_sales_controller.dart';

//ignore: must_be_immutable
class CreateSalesView extends BaseView<CreateSalesController> {
  CreateSalesView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildProductSearchForm(),
            _buildStockAddForm(),
            _buildSelectedStockList(),
          ],
        ),
        _buildSearchedStockList(),
      ],
    );
  }

  @override
  Widget floatingActionButton() {
    return InkWell(
      onTap: () {
        if (controller.salesItemList.isEmpty) {
          toast('please_select_item'.tr);
          return;
        }

        /* if (Get.isRegistered<SalesProcessModalController>()) {
          Get.delete<SalesProcessModalController>();
        }

        showDialog(
          context: context,
          builder: (context) {
            return SalesProcessModalView(
              salesItemList: mvc.salesItemList,
              preSales: null,
            );
          },
        ).then(
          (value) {
            if (value != null) {
              mvc
                ..updateSalesItemList(value)
                ..salesItemList.value = value
                ..calculateAllSubtotal();

              mvc.salesItemList.refresh();
            }
          },
        );*/
      },
      child: Container(
        height: 7.ph,
        width: Get.width,
        color: colors.primaryBaseColor,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          bottom: 7,
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: spaceBetweenMAA,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                margin: const EdgeInsets.only(
                  left: 8,
                ),
                child: Row(
                  mainAxisAlignment: centerMAA,
                  children: [
                    Text(
                      'place_order'.tr,
                      style: TextStyle(
                        color: colors.backgroundColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              60.width,
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 32,
                  right: 32,
                ),
                margin: const EdgeInsets.only(
                  bottom: 4,
                  top: 4,
                  right: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: colors.primaryLiteColor,
                ),
                child: Row(
                  mainAxisAlignment: centerMAA,
                  children: [
                    Text(
                      '${controller.salesItemList.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      ' | ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${controller.salesSubTotal}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSearchForm() {
    return Obx(
      () => ProductSearchForm(
        searchController: controller.searchController.value,
        onSearch: controller.getStocks,
        autoFocus: controller.selectedStock.value == null,
        isShowSuffixIcon: controller.searchController.value.text.isNotEmpty,
        onClear: controller.onClearSearchField,
        selectedStock: controller.selectedStock.value,
      ),
    );
  }

  Widget _buildStockAddForm() {
    return Obx(
      () {
        return Visibility(
          visible: controller.selectedStock.value != null &&
              !controller.showSalesItem.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                dimensions.containerBorderRadius,
              ),
              color: colors.evenListColor,
            ),
            margin: zero,
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
            ),
            child: Column(
              crossAxisAlignment: startCAA,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: 8,
                    right: 8,
                  ),
                  child: Text(
                    controller.selectedStock.value?.name ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: dimensions.paragraphTFSize,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryTextColor,
                    ),
                  ),
                ),
                5.height,
                Container(
                  margin: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: zero,
                          padding: zero,
                          height: dimensions.mediumTextFieldHeight,
                          //width: Get.width * 0.6,
                          color: colors.textFieldColor,
                          child: TextFormField(
                            controller: controller.stockMrpController.value,
                            textAlign: TextAlign.center,
                            keyboardType: numberInputType,
                            inputFormatters: [
                              regexDouble,
                            ],
                            textInputAction: nextInputAction,
                            style: TextStyle(
                              fontSize: dimensions.mediumTFSize,
                              color: colors.primaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: colors.formCursorColor,
                            decoration: getInputDecoration(
                              hint: 'mrp'.tr,
                            ),
                          ),
                        ),
                      ),
                      4.width,
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: zero,
                          padding: zero,
                          height: dimensions.mediumTextFieldHeight,
                          //width: Get.width * 0.6,
                          color: colors.textFieldColor,
                          child: TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            focusNode: controller.qtyFocusNode.value,
                            controller: controller.stockQtyController.value,
                            style: TextStyle(
                              fontSize: dimensions.mediumTFSize,
                              color: colors.primaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: colors.formCursorColor,
                            decoration: getInputDecoration(
                              hint: 'qty'.tr,
                            ),
                            keyboardType: numberInputType,
                            inputFormatters: doubleInputFormatter,
                            textInputAction: nextInputAction,
                          ),
                        ),
                      ),
                      4.width,
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: zero,
                          padding: zero,
                          height: dimensions.mediumTextFieldHeight,
                          //width: Get.width * 0.6,
                          color: colors.textFieldColor,
                          child: TextFormField(
                            controller:
                                controller.stockDiscountPercentController.value,
                            textAlign: TextAlign.center,
                            keyboardType: numberInputType,
                            inputFormatters: [
                              regexDouble,
                            ],
                            textInputAction: nextInputAction,
                            onEditingComplete: () {
                              if (controller.selectedStock.value != null) {
                                controller.addSaleItem(
                                  process: '',
                                );
                              }
                            },
                            style: TextStyle(
                              fontSize: dimensions.mediumTFSize,
                              color: colors.primaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: colors.formCursorColor,
                            decoration: getInputDecoration(
                              hint: '%',
                            ),
                          ),
                        ),
                      ),
                      8.width,
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          //  margin: const EdgeInsets.all(5),
                          height: dimensions.mediumTextFieldHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.selectedStock.value != null) {
                                controller.addSaleItem(
                                  process: '',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  dimensions.containerBorderRadius,
                                ),
                              ),
                              backgroundColor: colors.primaryBaseColor,
                            ),
                            child: CommonText(
                              text: 'add'.tr,
                              textColor: colors.backgroundColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedStockList() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Obx(
              () {
                return Visibility(
                  visible: controller.salesItemList.isNotEmpty,
                  child: Column(
                    children: [
                      4.height,
                      const SelectedStockListHeader(),
                      4.height,
                      SizedBox(
                        height: 65.ph,
                        child: SalesItemListView(
                          salesItems: controller.salesItemList,
                          onItemRemove: controller.onItemRemove,
                          onQtyChange: controller.onQtyChange,
                          onDiscountChange: controller.onDiscountChange,
                          onSalesPriceChange: controller.onSalesPriceChange,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              color: colors.backgroundColor,
              height: 90.ph,
              child: Column(
                children: [
                  Obx(
                    () {
                      return Visibility(
                        visible: controller.salesItemList.isEmpty &&
                            controller.stockList.value.isEmpty,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40.ph,
                          width: 100.pw,
                          child: Image.asset(
                            'assets/images/no-record-found.png',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchedStockList() {
    return Obx(
      () => Visibility(
        visible: controller.stockList.value.isNotEmpty,
        child: Positioned(
          top: 50,
          left: 0,
          right: 0,
          bottom: 0,
          child: Obx(
            () => DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  dimensions.containerBorderRadius,
                ),
                color: colors.evenListColor,
              ),
              child: SearchedStockList(
                stocks: controller.stockList.value,
                onItemTap: controller.onStockSelection,
                onQtyChange: controller.onSearchedStockQtyChange,
                onQtyEditComplete: controller.onSearchedStockQtyEditComplete,
              ),
            ),
          ),
        ),
      ),
    );
  }
}