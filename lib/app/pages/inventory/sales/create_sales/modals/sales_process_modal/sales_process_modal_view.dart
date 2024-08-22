import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';

import '/app/core/advance_select/advance_select_view.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/entity/sales.dart';
import '/app/entity/sales_item.dart';
import '/app/entity/user.dart';
import '/app/global_widget/customer_card_view.dart';
import '/app/global_widget/transaction_method_item_view.dart';
import '/app/pages/inventory/sales/create_sales/modals/sales_process_modal/sales_process_modal_controller.dart';

class SalesProcessModalView extends BaseView<SalesProcessModalController> {
  final Sales? preSales;
  final List<SalesItem> salesItemList;
  SalesProcessModalView({
    required this.salesItemList,
    required this.preSales,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<SalesProcessModalController>(
      init: SalesProcessModalController(
        salesItemList: salesItemList,
        preSales: preSales,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Column(
                          children: [
                            //_buildSelectedCustomerView(context),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 1,
                                      color: colors.borderColor,
                                    ),
                                    8.height,
                                    _buildInvoiceSummery(),
                                    8.height,
                                    Container(
                                      height: 1,
                                      color: colors.borderColor,
                                    ),
                                    4.height,
                                    _buildTransactionMethod(context),
                                    0.25.percentHeight,
                                    _buildPaymentReceiveRow(context),
                                    1.percentHeight,
                                    _buildUserSelectView(context),
                                    1.percentHeight,
                                    //_buildProfitView(context),
                                    Container(
                                      height: 1,
                                      color: colors.borderColor,
                                    ),
                                    8.height,
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

  InputDecoration buildInputDecoration({
    required String hintText,
    required TextStyle hintStyle,
    required Color fillColor,
    required Color enabledBorderColor,
    required Color focusedBorderColor,
    required Color errorBorderColor,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 8,
          ),
      hintText: hintText,
      hintStyle: hintStyle,
      filled: true,
      fillColor: fillColor,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        borderSide: BorderSide(
          color: enabledBorderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        borderSide: BorderSide(
          color: focusedBorderColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        borderSide: BorderSide(color: errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 0,
        ),
      ),
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
            left: 12,
            bottom: 8,
            right: 12,
          ),
          decoration: BoxDecoration(
            color: colors.primaryBaseColor,
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
                  fontWeight: FontWeight.w600,
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
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.back(result: controller.salesItemList);
                          },
                          child: Icon(
                            TablerIcons.x,
                            size: closeIconSize,
                            color: colors.backgroundColor,
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
      ],
    );
  }

  Widget _buildCustomerSearch(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
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
                        controller.customerManager.searchTextController.value,
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
                                        controller.customerManager
                                            .searchTextController.value
                                            .clear();
                                        controller.isShowClearIcon.value =
                                            false;
                                        controller.customerManager.selectedItem
                                            .value = null;
                                      },
                                      child: Icon(
                                        TablerIcons.x,
                                        size: 12,
                                        color: colors.formClearIconColor,
                                      ),
                                    )
                                  : Container(),
                              IconButton(
                                onPressed: controller.addCustomer,
                                icon: const Icon(
                                  TablerIcons.user_plus,
                                  size: 20,
                                  color: Color(0xFFC98A69),
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
                      hintText: appLocalization.searchCustomer,
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
                      if (value.isEmpty ?? true) {
                        controller.isShowClearIcon.value = false;
                        controller.customerManager.searchedItems.value = [];
                        controller.customerManager.selectedItem.value = null;
                        return;
                      }
                      controller.isShowClearIcon.value = true;
                      await controller.customerManager.searchItemsByName(value);
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
                text: appLocalization.donNotHaveAnAccount,
                fontSize: smallTFSize,
                fontWeight: FontWeight.w400,
                textColor: colors.textColorH6,
              ),
              InkWell(
                onTap: controller.addCustomer,
                child: CommonText(
                  text: appLocalization.addCustomer,
                  fontSize: mediumTFSize,
                  fontWeight: FontWeight.w500,
                  textColor: colors.primaryBaseColor,
                  textDecoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          Obx(
            () => controller.customerManager.selectedItem.value != null
                ? Column(
                    children: [
                      1.percentHeight,
                      CustomerCardView(
                        data: controller.customerManager.selectedItem.value!,
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

  Widget _buildSelectedCustomerView(
    BuildContext context,
  ) {
    return Obx(
      () => controller.customerManager.selectedItem.value != null
          ? Column(
              children: [
                1.percentHeight,
                CustomerCardView(
                  data: controller.customerManager.selectedItem.value!,
                  index: 0,
                  onTap: () {},
                  onReceive: () {},
                  showReceiveButton: false,
                ),
                1.percentHeight,
              ],
            )
          : Container(),
    );
  }

  Widget _buildCustomerListView(
    BuildContext context,
  ) {
    return Obx(
      () => controller.customerManager.searchedItems.value?.isNotEmpty ?? false
          ? Container(
              color: Colors.white,
              height: 40.ph,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    controller.customerManager.searchedItems.value?.length ?? 0,
                itemBuilder: (context, index) {
                  return CustomerCardView(
                    data:
                        controller.customerManager.searchedItems.value![index],
                    index: index,
                    onTap: () {
                      controller.updateCustomer(
                        controller.customerManager.searchedItems.value![index],
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
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 4,
                  ),
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () {
                          return Text(
                            '${SetUp().currency ?? ''} ${controller.salesSubTotal.value.toString()}',
                            style: TextStyle(
                              fontSize: regularTFSize,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      4.height,
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                        ),
                        width: Get.width * 0.1,
                        color: const Color(0xFFff3232),
                      ),
                      4.height,
                      Text(
                        appLocalization.subTotal,
                        style: TextStyle(
                          fontSize: smallTFSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () {
                          return Text(
                            '${SetUp().currency ?? ''} ${controller.salesDiscount.value.toString()}',
                            style: TextStyle(
                              fontSize: regularTFSize,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      4.height,
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                        ),
                        width: Get.width * 0.1,
                        color: const Color(0xFFff3232),
                      ),
                      4.height,
                      Text(
                        appLocalization.discount,
                        style: TextStyle(
                          fontSize: smallTFSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () {
                          return Text(
                            '${SetUp().currency ?? ''} ${controller.salesVat.value.toString()}',
                            style: TextStyle(
                              fontSize: regularTFSize,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      4.height,
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                        ),
                        width: Get.width * 0.1,
                        color: const Color(0xFFff3232),
                      ),
                      4.height,
                      Text(
                        appLocalization.vat,
                        style: TextStyle(
                          fontSize: smallTFSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 4,
                  ),
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: colors.primaryBaseColor,
                  ),
                  child: Column(
                    mainAxisAlignment: centerMAA,
                    children: [
                      Obx(
                        () {
                          return Text(
                            '${SetUp().currency ?? ''} ${controller.netTotal.value.toString()}',
                            style: TextStyle(
                              fontSize: regularTFSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      4.height,
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                        ),
                        width: Get.width * 0.1,
                        color: Colors.white,
                      ),
                      4.height,
                      Text(
                        appLocalization.total,
                        style: TextStyle(
                          fontSize: smallTFSize,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
          0.25.percentHeight,
          if (controller.transactionMethodsManager.allItems.value != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 4,
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
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: colors.borderColor,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () {
                          return AdvancedSwitch(
                            activeChild: Text('%'.tr),
                            inactiveChild: Text(appLocalization.flat),
                            activeColor: colors.successfulBaseColor,
                            inactiveColor: colors.primaryLiteColor,
                            borderRadius: BorderRadius.circular(
                              containerBorderRadius,
                            ),
                            height: 24,
                            controller: controller.discountTypeController.value,
                          );
                        },
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: SizedBox(
                        height: 24,
                        child: TextFormField(
                          controller:
                              controller.paymentDiscountController.value,
                          cursorColor: colors.formCursorColor,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: buildInputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            hintText: appLocalization.discount,
                            hintStyle: TextStyle(
                              color: colors.formBaseHintTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: mediumTFSize,
                            ),
                            fillColor: colors.textFieldColor,
                            enabledBorderColor: colors.primaryBaseColor,
                            focusedBorderColor: colors.borderColor,
                            errorBorderColor: colors.borderColor,
                          ),
                          inputFormatters: doubleInputFormatter,
                          keyboardType: numberInputType,
                          textAlign: centerTA,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: mediumTFSize,
                          ),
                          onChanged: controller.onDiscountChange,
                        ),
                      ),
                    ),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Expanded(
                      child: AdvancedSwitch(
                        activeChild: Text(
                          appLocalization.yes,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: smallTFSize,
                          ),
                        ),
                        inactiveChild: Text(
                          appLocalization.profit,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: smallTFSize,
                          ),
                        ),
                        activeColor: colors.selectedColor,
                        inactiveColor: colors.primaryBaseColor,
                        borderRadius: BorderRadius.circular(4),
                        height: 24,
                        controller: controller.showProfit.value,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: Container(
                        width: 100,
                        child: Obx(
                          () => CommonText(
                            text: controller.showProfit.value.value
                                ? (controller.netTotal.value -
                                        controller.salesPurchasePrice.value)
                                    .toPrecision(2)
                                    .toString()
                                : '',
                            fontWeight: FontWeight.w400,
                            fontSize: smallTFSize,
                            textColor: colors.defaultFontColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        8.width,
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: colors.borderColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        containerBorderRadius,
                      ),
                      color: const Color(0xFFEEDBD1),
                    ),
                    child: Column(
                      mainAxisAlignment: centerMAA,
                      children: [
                        Obx(
                          () => Text(
                            controller.salesReturnValue.value.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: mediumTFSize,
                            ),
                          ),
                        ),
                        4.height,
                        Container(
                          height: 1,
                          margin: const EdgeInsets.only(
                            top: 1,
                            bottom: 1,
                          ),
                          width: Get.width * 0.1,
                          color: const Color(0xFFC98A69),
                        ),
                        4.height,
                        Obx(
                          () => Text(
                            controller.returnMsg.value,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: mediumTFSize,
                              color: colors.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                8.width,
                Expanded(
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
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 4,
                      ),
                      hintText: appLocalization.amount,
                      hintStyle: TextStyle(
                        color: colors.formBaseHintTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize: regularTFSize,
                      ),
                      fillColor: colors.textFieldColor,
                      enabledBorderColor: colors.primaryBaseColor,
                      focusedBorderColor: colors.primaryBaseColor,
                      errorBorderColor: colors.primaryBaseColor,
                    ),
                    onChanged: controller.onAmountChange,
                  ),
                ),
              ],
            ),
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

  Widget _buildProfitView(
    BuildContext context,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      width: Get.width * .4,
      child: Row(
        mainAxisAlignment: startMAA,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 4,
              right: 4,
            ),
            child: AdvancedSwitch(
              activeChild: Text(
                appLocalization.yes,
                style: TextStyle(
                  color: colors.primaryTextColor,
                  fontSize: smallTFSize,
                ),
              ),
              inactiveChild: Text(
                appLocalization.profit,
                style: TextStyle(
                  color: colors.primaryTextColor,
                  fontSize: smallTFSize,
                ),
              ),
              activeColor: colors.selectedColor,
              inactiveColor: colors.moduleHeaderColor,
              borderRadius: BorderRadius.circular(4),
              width: 64,
              height: 24,
              controller: controller.showProfit.value,
            ),
          ),
          Container(
            height: 3.ph,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.evenListColor,
              borderRadius: BorderRadius.circular(
                containerBorderRadius,
              ),
            ),
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(left: 4, right: 4),
            child: Obx(
              () => CommonText(
                text: controller.showProfit.value.value
                    ? (controller.netTotal.value -
                            controller.salesPurchasePrice.value)
                        .toPrecision(2)
                        .toString()
                    : '',
                fontWeight: FontWeight.w500,
                fontSize: smallTFSize,
                textColor: colors.primaryBaseColor,
              ),
            ),
          ),
        ],
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
          8.width,
          RowButton(
            buttonName: appLocalization.hold,
            onTap: () => controller.hold(context),
            leftIcon: TablerIcons.progress,
            buttonBGColor: const Color(0xFFFAF3F0),
            buttonTextColor: const Color(0xFFC98A69),
            isOutline: true,
          ),
          8.width,
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
