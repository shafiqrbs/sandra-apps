import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/list_button.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/selected_stock_list_header.dart';
import '/app/global_widget/product_search_form.dart';
import '/app/pages/inventory/purchase/create_purchase/controllers/create_purchase_controller.dart';
import '/app/pages/inventory/sales/create_sales/component/sales_item_list_view.dart';
import '/app/pages/inventory/sales/create_sales/component/searched_stock_list.dart';

//ignore: must_be_immutable
class CreatePurchaseView extends BaseView<CreatePurchaseController> {
  CreatePurchaseView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Text(
        'create_purchase'.tr,
        style: TextStyle(
          color: colors.backgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        AppBarButtonGroup(
          children: [
            ListButton(
              onTap: controller.goToListPage,
            ),
            QuickNavigationButton(),
          ],
        ),
      ],
    );
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
                containerBorderRadius,
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
                      fontSize: paragraphTFSize,
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
                          height: mediumTextFieldHeight,
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
                              fontSize: mediumTFSize,
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
                          height: mediumTextFieldHeight,
                          //width: Get.width * 0.6,
                          color: colors.textFieldColor,
                          child: TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            focusNode: controller.qtyFocusNode.value,
                            controller: controller.stockQtyController.value,
                            style: TextStyle(
                              fontSize: mediumTFSize,
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
                          height: mediumTextFieldHeight,
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
                              fontSize: mediumTFSize,
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
                          height: mediumTextFieldHeight,
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
                                  containerBorderRadius,
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
                  visible: controller.salesItemList.value.isNotEmpty,
                  child: Column(
                    children: [
                      4.height,
                      const SelectedStockListHeader(),
                      4.height,
                      SizedBox(
                        height: 65.ph,
                        child: SalesItemListView(
                          salesItems: controller.salesItemList.value,
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
                        visible: controller.salesItemList.value.isEmpty &&
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
                  containerBorderRadius,
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
