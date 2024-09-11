import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/utils/style_function.dart';

import '/app/core/advance_select/advance_select_view.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/entity/purchase.dart';
import '/app/entity/purchase_item.dart';
import '/app/entity/user.dart';
import '/app/global_widget/transaction_method_item_view.dart';
import '/app/global_widget/vendor_card_view.dart';
import 'purchase_process_controller.dart';

class PurchaseProcessView extends BaseView<PurchaseProcessController> {
  final Purchase? prePurchase;
  final List<PurchaseItem> purchaseItemList;
  PurchaseProcessView({
    required this.purchaseItemList,
    required this.prePurchase,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<PurchaseProcessController>(
      init: PurchaseProcessController(
        itemList: purchaseItemList,
        prePurchase: prePurchase,
      ),
      builder: (controller) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black.withOpacity(.5),
          shadowColor: Colors.white.withOpacity(.8),
          elevation: 0,
          child: Center(
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  containerBorderRadius,
                ),
                color: colors.backgroundColor,
              ),
              child: Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: centerMAA,
                    children: [
                      _buildSalesItemListView(context),
                      1.percentHeight,
                      _buildCustomerSearch(context),
                      //1.percentHeight,
                      //_buildSelectedCustomerView(context),
                      Stack(
                        children: [
                          Column(
                            children: [

                              _buildTransactionMethod(context),
                              _buildInvoiceSummery(),
                              1.percentHeight,
                              _buildUserSelectView(context),
                              1.percentHeight,
                              _buildBottomButton(context),
                              1.percentHeight,
                            ],
                          ),
                          _buildCustomerListView(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  Widget _buildSalesItemListView(
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          height: 5.ph,
          width: Get.width,
          padding: const EdgeInsets.only(
            top: 8,
            left: 8,
            bottom: 8,
            right: 4,
          ),
          decoration: BoxDecoration(
            color: colors.primaryColor500,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                containerBorderRadius,
              ),
              topRight: Radius.circular(
                containerBorderRadius,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: CommonText(
                  text: appLocalization.placeOrder,
                  fontSize: subHeaderTFSize,
                  fontWeight: FontWeight.bold,
                  textColor: colors.backgroundColor,
                ),
              ),
              4.width,
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                           Get.back(result: controller.purchaseItemList);
                        },
                        child: Icon(
                          TablerIcons.x,
                          size: closeIconSize,
                          color: colors.backgroundColor,
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
    );
  }

  Widget _buildCustomerSearch(
      BuildContext context,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      color: colors.backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: textFieldHeight,
                  child: TextFormField(
                    controller:
                    controller.vendorManager.searchTextController.value,
                    cursorColor: colors.formCursorColor,
                    decoration: buildInputDecoration(
                      prefixIcon: Icon(
                        TablerIcons.search,
                        size: 16,
                        color: colors.formBaseHintTextColor,
                      ),
                      suffixIcon: Obx(
                            () {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              controller.isShowClearIcon.value
                                  ? InkWell(
                                onTap: () {
                                  controller.vendorManager
                                      .searchTextController.value
                                      .clear();
                                  controller.isShowClearIcon.value =
                                  false;
                                  controller.vendorManager.selectedItem
                                      .value = null;
                                  controller.vendorManager.searchedItems
                                      .value = [];
                                },
                                child: Icon(
                                  TablerIcons.x,
                                  size: 12,
                                  color: colors.formClearIconColor,
                                ),
                              )
                                  : Container(),
                              IconButton(
                                onPressed: controller.addVendor,
                                icon: Icon(
                                  TablerIcons.user_plus,
                                  size: 20,
                                  color: colors.primaryColor500,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      hintText: appLocalization.searchVendor,
                      hintStyle: TextStyle(
                        color: colors.formBaseHintTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize: mediumTFSize.sp,
                      ),
                      fillColor: colors.textFieldColor,
                      enabledBorderColor: colors.borderColor,
                      focusedBorderColor: colors.borderColor,
                      errorBorderColor: colors.borderColor,
                    ),
                    textAlign: startTA,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: mediumTFSize.sp,
                    ),
                    onChanged: (value) async {
                      if (value.isEmpty) {
                        controller.isShowClearIcon.value = false;
                        controller.vendorManager.searchedItems.value = [];
                        controller.vendorManager.selectedItem.value = null;
                        return;
                      }
                      controller.isShowClearIcon.value = true;
                      await controller.vendorManager.searchItemsByName(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          4.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                text: appLocalization.dontYouHaveVendor,
                fontSize: smallTFSize,
                fontWeight: FontWeight.w400,
                textColor: colors.textColorH6,
              ),
              InkWell(
                onTap: controller.addVendor,
                child: CommonText(
                  text: appLocalization.addVendor,
                  fontSize: mediumTFSize,
                  fontWeight: FontWeight.w500,
                  textColor: colors.primaryColor500,
                  textDecoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          Obx(
                () => controller.vendorManager.selectedItem.value != null
                ? Column(
              children: [
                1.percentHeight,
                VendorCardView(
                  data: controller.vendorManager.selectedItem.value!,
                  index: 0,
                  onTap: () {},
                  onReceive: () {},
                  showReceiveButton: false,
                ),
              ],
            )
                : Container(),
          ),
          8.height,
        ],
      ),
    );
  }

  Widget _buildCustomerSearch2(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: FBString(
            isRequired: false,
            textController: controller.vendorManager.searchTextController.value,
            onChange: (value) async {
              if (value?.isEmpty ?? true) {
                controller.vendorManager.searchedItems.value = [];
                controller.vendorManager.selectedItem.value = null;
                return;
              }
              await controller.vendorManager.searchItemsByName(value!);
            },
            hint: appLocalization.searchVendor,
            suffixIcon: TablerIcons.search,
          ),
        ),
        2.percentWidth,
        Expanded(
          child: GestureDetector(
            onTap: controller.addVendor,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.moduleHeaderColor,
                ),
                borderRadius: BorderRadius.circular(4),
                color: colors.moduleHeaderColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    TablerIcons.user_plus,
                    size: 28,
                    color: colors.secondaryTextColor,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'vendor',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCustomerView(
    BuildContext context,
  ) {
    return Obx(
      () {
        return controller.vendorManager.selectedItem.value != null
            ? Column(
                children: [
                  1.percentHeight,
                  VendorCardView(
                    data: controller.vendorManager.selectedItem.value!,
                    index: 0,
                    onTap: () {},
                    onReceive: () {},
                    showReceiveButton: false,
                  ),
                  1.percentHeight,
                ],
              )
            : Container();
      },
    );
  }

  Widget _buildCustomerListView(
    BuildContext context,
  ) {
    return Obx(
      () => controller.vendorManager.searchedItems.value?.isNotEmpty ?? false
          ? Container(
              color: Colors.white,
              height: 40.ph,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    controller.vendorManager.searchedItems.value?.length ?? 0,
                itemBuilder: (context, index) {
                  return VendorCardView(
                    data: controller.vendorManager.searchedItems.value![index],
                    index: index,
                    onTap: () {
                      controller.updateVendor(
                        controller.vendorManager.searchedItems.value![index],
                      );
                      FocusScope.of(context).unfocus();
                    },
                    onReceive: () {},
                    showReceiveButton: false,
                  );
                },
              ),
            )
          : Container(),
    );
  }

  Widget _buildInvoiceSummery() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              left: 4,
              right: 4,
            ),
            padding: const EdgeInsets.only(
              top: 4,
              bottom: 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colors.primaryColor50,
            ),
            child: Column(
              mainAxisAlignment: centerMAA,
              children: [
                Obx(
                  () => Text(
                    controller.netTotal.value.toString(),
                    style: TextStyle(
                      fontSize: regularTFSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.only(
                    top: 1,
                    bottom: 1,
                  ),
                  width: Get.width * 0.1,
                  color: colors.dangerBaseColor,
                ),
                Text(
                  appLocalization.total,
                  style: TextStyle(
                    fontSize: smallTFSize,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                  ),
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      containerBorderRadius,
                    ),
                    color: colors.primaryColor50,
                  ),
                  child: Column(
                    mainAxisAlignment: centerMAA,
                    children: [
                      Obx(
                        () => Text(
                          controller.purchaseReturnValue.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: mediumTFSize,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.returnMsg.value.tr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  height: textFieldHeight,
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: controller.amountController.value,
                    inputFormatters: doubleInputFormatter,
                    textInputAction: doneInputAction,
                    onEditingComplete: () => controller.showConfirmationDialog(
                      Get.overlayContext!,
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: regularTFSize,
                    ),
                    cursorColor: colors.formCursorColor,
                    decoration: buildInputDecoration(
                      hintText: appLocalization.amount,
                      hintStyle: TextStyle(
                        color: colors.formBaseHintTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize: regularTFSize,
                      ),
                      fillColor: colors.textFieldColor,
                      enabledBorderColor: colors.primaryColor200,
                      focusedBorderColor: colors.primaryColor500,
                      errorBorderColor: colors.primaryColor200,
                    ),
                    onChanged: controller.onAmountChange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionMethod(
    BuildContext context,
  ) {
    return Obx(
      () => Column(
        children: [
          if (controller.transactionMethodsManager.allItems.value != null)
            SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                runSpacing: 8,
                children:
                    controller.transactionMethodsManager.allItems.value!.map(
                  (e) {
                    final selected =
                        controller.transactionMethodsManager.selectedItem.value;
                    return TransactionMethodItemView(
                      method: e,
                      isSelected: selected == e,
                      onTap: () {
                        controller
                            .transactionMethodsManager.selectedItem.value = e;
                      },
                    );
                  },
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentReceiveRow(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                  ),
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      containerBorderRadius,
                    ),
                    color: colors.dangerBaseColor.withOpacity(.3),
                  ),
                  child: Column(
                    mainAxisAlignment: centerMAA,
                    children: [
                      Obx(
                        () => Text(
                          controller.purchaseReturnValue.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: mediumTFSize,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.returnMsg.value.tr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  height: textFieldHeight,
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: controller.amountController.value,
                    inputFormatters: doubleInputFormatter,
                    textInputAction: doneInputAction,
                    onEditingComplete: () =>
                        controller.showConfirmationDialog(context),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: regularTFSize,
                    ),
                    cursorColor: colors.formCursorColor,
                    decoration: buildInputDecoration(
                      hintText: appLocalization.amount,
                      hintStyle: TextStyle(
                        color: colors.formBaseHintTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize: regularTFSize,
                      ),
                      fillColor: colors.textFieldColor,
                      enabledBorderColor: colors.primaryBaseColor,
                      focusedBorderColor: colors.borderColor,
                      errorBorderColor: colors.borderColor,
                    ),
                    onChanged: controller.onAmountChange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserSelectView(
    BuildContext context,
  ) {
    return Obx(
      () => AdvanceSelect<User>(
        isRequired: true,
        isShowSearch: false,
        controller: controller.userManager.value.asController,
        itemToString: (data) => data?.fullName ?? '',
        hint: appLocalization.selectUser,
      ),
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        left: 4,
        right: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RowButton(
            buttonName: appLocalization.reset,
            onTap: () => controller.reset(context),
            leftIcon: TablerIcons.restore,
            buttonBGColor: Colors.transparent,
            isOutline: true,
          ),
          4.width,
          RowButton(
            buttonName: appLocalization.hold,
            onTap: () => controller.hold(context),
            leftIcon: TablerIcons.progress,
            buttonBGColor: colors.primaryColor50,
            buttonTextColor: colors.primaryColor500,
            isOutline: false,
          ),
          4.width,
          RowButton(
            buttonName: appLocalization.order,
            onTap: () => controller.showConfirmationDialog(context),
            leftIcon: TablerIcons.device_floppy,
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO(saiful): implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO(saiful): implement body
    throw UnimplementedError();
  }
}
