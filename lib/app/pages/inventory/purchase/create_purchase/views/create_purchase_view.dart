import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/values/drop_down_decoration.dart';
import 'package:sandra/app/entity/brand.dart';
import 'package:sandra/app/global_widget/place_order_view.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/list_button.dart';
import '/app/core/widget/page_back_button.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/selected_stock_list_header.dart';
import '/app/global_widget/product_search_form.dart';
import '/app/pages/inventory/purchase/create_purchase/component/purchase_item_list_view.dart';
import '/app/pages/inventory/purchase/create_purchase/component/searched_purchase_stock_list.dart';
import '/app/pages/inventory/purchase/create_purchase/controllers/create_purchase_controller.dart';

//ignore: must_be_immutable
class CreatePurchaseView extends BaseView<CreatePurchaseController> {
  CreatePurchaseView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: PageBackButton(
        pageTitle: appLocalization.createPurchase,
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
            // _buildBrandDropDown(),
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
  Widget? floatingActionButton() {
    return Obx(
      () {
        final showPlaceOrderButton = controller.stockList.value.isEmpty;
        final showAddStockButton = controller.isShowAddStockButton.value;

        if (showPlaceOrderButton) {
          return PlaceOrderView(
            onTap: controller.onSave,
            count: controller.purchaseItemList.value.length.toString(),
            total: controller.purchaseSubTotal.toString(),
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
                top: 0,
                bottom: 0,
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
          Obx(
            () => ProductSearchForm(
              searchController: controller.searchController.value,
              onSearch: controller.getStocks,
              autoFocus: controller.selectedStock.value == null,
              isShowSuffixIcon: controller.searchController.value.text != '',
              onClear: controller.onClearSearchField,
              selectedStock: controller.selectedStock.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockAddForm() {
    return Obx(
      () {
        return Visibility(
          visible: controller.selectedStock.value != null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                containerBorderRadius,
              ),
              color: colors.secondaryColor50,
            ),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const Divider(),
                Container(
                  margin: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              appLocalization.qty,
                              style: TextStyle(
                                fontSize: smallTFSize,
                                color: colors.solidBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            4.height,
                            Container(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
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
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  regexDouble,
                                ],
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () {
                                  if (controller.selectedStock.value != null) {
                                    controller.addPurchaseItem(
                                      process: '',
                                    );
                                  }
                                },
                                onChanged: controller.onAddStockQtyChange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      4.width,
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              controller.purchaseMode
                                      ?.replaceAll('_', ' ')
                                      .toUpperCase() ??
                                  '',
                              style: TextStyle(
                                fontSize: smallTFSize,
                                color: colors.solidBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            4.height,
                            Container(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              height: mediumTextFieldHeight,
                              //width: Get.width * 0.6,
                              color: colors.primaryColor50,
                              child: TextFormField(
                                controller: controller.priceController.value,
                                readOnly:
                                    controller.purchaseMode == 'item_percent',
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  regexDouble,
                                ],
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                  fontSize: mediumTFSize,
                                  color: colors.solidBlackColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                cursorColor: colors.solidBlackColor,
                                decoration: getInputDecoration(
                                  hint: appLocalization.price,
                                ),
                                onChanged: controller.onAddStockQtyChange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      8.width,
                      if (controller.purchaseMode == 'total_price')
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                appLocalization.totalPrice,
                                style: TextStyle(
                                  fontSize: smallTFSize,
                                  color: colors.solidBlackColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              4.height,
                              Container(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                height: mediumTextFieldHeight,
                                //width: Get.width * 0.6,
                                color: colors.primaryColor50,
                                child: TextFormField(
                                  controller:
                                      controller.totalPriceController.value,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    regexDouble,
                                  ],
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () {
                                    if (controller.selectedStock.value !=
                                        null) {
                                      controller.addPurchaseItem(
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
                                    hint: appLocalization.totalPrice,
                                  ),
                                  onChanged: controller.onTotalPriceChange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: smallTFSize,
                                color: colors.solidBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              //  margin: const EdgeInsets.all(5),
                              height: mediumTextFieldHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (controller.selectedStock.value != null) {
                                    controller.addPurchaseItem(
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
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
                  visible: controller.purchaseItemList.value.isNotEmpty &&
                      controller.purchaseMode != null,
                  child: Column(
                    children: [
                      4.height,
                      SelectedStockListHeader(),
                      4.height,
                      SizedBox(
                        height: 75.ph,
                        child: PurchaseItemListView(
                          salesItems: controller.purchaseItemList.value,
                          onItemRemove: controller.onItemRemove,
                          onQtyChange: controller.onQtyChange,
                          onPriceChange: controller.onPriceChange,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              color: colors.whiteColor,
              height: 90.ph,
              child: Column(
                children: [
                  Obx(
                    () {
                      return Visibility(
                        visible: controller.purchaseItemList.value.isEmpty &&
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
          top: controller.isShowBrand.value ? 100 : 50,
          left: 0,
          right: 0,
          bottom: 0,
          child: Obx(
            () => DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  containerBorderRadius,
                ),
                color: colors.whiteColor,
              ),
              child: SearchedPurchaseStockList(
                stocks: controller.stockList.value,
                onItemTap: controller.onStockSelection,
                onQtyChange: controller.onSearchedStockQtyChange,
                onQtyEditComplete: controller.onSearchedStockQtyEditComplete,
                qtyControllerList: controller.qtyControllerList,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
