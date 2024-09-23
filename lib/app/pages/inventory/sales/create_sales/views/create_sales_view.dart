import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/values/drop_down_decoration.dart';
import 'package:sandra/app/entity/brand.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/list_button.dart';
import '/app/core/widget/no_record_found_view.dart';
import '/app/core/widget/page_back_button.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/selected_stock_list_header.dart';
import '/app/global_widget/product_search_form.dart';
import '/app/pages/inventory/sales/create_sales/component/sales_item_list_view.dart';
import '/app/pages/inventory/sales/create_sales/component/searched_stock_list.dart';
import '/app/pages/inventory/sales/create_sales/controllers/create_sales_controller.dart';

//ignore: must_be_immutable
class CreateSalesView extends BaseView<CreateSalesController> {
  CreateSalesView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: PageBackButton(
        pageTitle: appLocalization.createSales,
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

  @override
  Widget floatingActionButton() {
    return Obx(
      () {
        final showPlaceOrderButton = controller.stockList.value.isEmpty;
        final showAddStockButton = controller.isShowAddStockButton.value;

        if (showPlaceOrderButton) {
          return InkWell(
            onTap: controller.showOrderProcessModal,
            child: Container(
              height: 7.ph,
              width: Get.width,
              color: colors.primaryColor400,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 7,
              ),
              child: Obx(
                () {
                  return Row(
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
                              appLocalization.placeOrder,
                              style: TextStyle(
                                color: colors.whiteColor,
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
                          color: colors.primaryColor200,
                        ),
                        child: Row(
                          mainAxisAlignment: centerMAA,
                          children: [
                            Text(
                              '${controller.salesItemList.value.length}',
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
                  );
                },
              ),
            ),
          );
        }
        if (showAddStockButton) {
          return InkWell(
            onTap: controller.addStockFromSearchList,
            child: Container(
              height: 7.ph,
              width: Get.width,
              color: colors.primaryColor400,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 7,
              ),
              child: Text(
                appLocalization.add,
                style: TextStyle(
                  color: colors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildProductSearchForm() {
    return Obx(
      () => Column(
        children: [
          Visibility(
            visible: controller.isShowBrand.value,
            child: Container(
              margin: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 4,
                right: 4,
              ),
              child: Stack(
                children: [
                  DropdownFlutter<Brand>.search(
                    controller: controller.brandManager.ddController,
                    hintText: appLocalization.brand,
                    items: controller.brandManager.allItems.value,
                    onChanged: controller.onBrandSelection,
                    overlayHeight: 500,
                    listItemBuilder: (context, value, ___, option) {
                      return Text(
                        value.name ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    headerBuilder: (context, value, option) {
                      return Text(
                        value.name ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    decoration: dropDownDecoration,
                    itemsListPadding: EdgeInsets.zero,
                    closedHeaderPadding: const EdgeInsets.all(8),
                  ),
                  if (controller.isShowBrandClearIcon.value)
                    Positioned(
                      right: 30,
                      top: 0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              TablerIcons.x,
                              color: colors.solidBlackColor,
                            ),
                            onPressed: () => controller.onBrandSelection(null),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
         Obx(()=> ProductSearchForm(
            searchController: controller.searchController.value,
            onSearch: controller.getStocks,
            autoFocus: controller.selectedStock.value == null,
            isShowSuffixIcon: controller.searchController.value.text != '',
            onClear: controller.onClearSearchField,
            selectedStock: controller.selectedStock.value,
          ),),
        ],
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
              color: colors.secondaryColor50,
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
                      color: colors.solidBlackColor,
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
                          color: colors.primaryColor50,
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
                              color: colors.solidBlackColor,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: colors.solidBlackColor,
                            decoration: getInputDecoration(
                              hint: appLocalization.mrp,
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
                          color: colors.primaryColor50,
                          child: TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            focusNode: controller.qtyFocusNode.value,
                            controller: controller.stockQtyController.value,
                            style: TextStyle(
                              fontSize: mediumTFSize,
                              color: colors.solidBlackColor,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: colors.solidBlackColor,
                            decoration: getInputDecoration(
                              hint: appLocalization.qty,
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
                          color: colors.primaryColor50,
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
                              color: colors.solidBlackColor,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: colors.solidBlackColor,
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
                              backgroundColor: colors.primaryColor500,
                            ),
                            child: CommonText(
                              text: appLocalization.add,
                              textColor: colors.whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
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
                      SelectedStockListHeader(),
                      4.height,
                      SizedBox(
                        height: 75.ph,
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
              color: colors.whiteColor,
              height: 80.ph,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () {
                      return Visibility(
                        visible: controller.salesItemList.value.isEmpty &&
                            controller.stockList.value.isEmpty,
                        child: NoRecordFoundView(
                          buttonText: appLocalization.pos,
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
          top: controller.isShowBrand.value ? 100 : 50,
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                containerBorderRadius,
              ),
              color: colors.whiteColor,
            ),
            child: SearchedStockList(
              stocks: controller.stockList.value,
              onItemTap: controller.onStockSelection,
              onQtyChange: controller.onSearchedStockQtyChange,
              onQtyEditComplete: controller.onSearchedStockQtyEditComplete,
              qtyControllerList: controller.qtyControllerList,
            ),
          ),
        ),
      ),
    );
  }
}
