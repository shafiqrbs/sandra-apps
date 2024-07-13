import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/advance_select/advance_select_view.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/global_modal/sales_process_modal/sales_process_modal_controller.dart';
import '/app/global_widget/customer_card_view.dart';
import '/app/global_widget/transaction_method_item_view.dart';
import '/app/entity/sales.dart';
import '/app/entity/sales_item.dart';
import '/app/entity/user.dart';

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
                      1.percentHeight,
                      _buildSelectedCustomerView(context),
                      Stack(
                        children: [
                          Column(
                            children: [
                              _buildInvoiceSummery(),
                              _buildTransactionMethod(context),
                              1.percentHeight,
                              _buildPaymentReceiveRow(context),
                              1.percentHeight,
                              _buildUserSelectView(context),
                              1.percentHeight,
                              _buildProfitView(context),
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

  InputDecoration buildInputDecoration({
    required String hintText,
    required TextStyle hintStyle,
    required Color fillColor,
    required Color enabledBorderColor,
    required Color focusedBorderColor,
    required Color errorBorderColor,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      hintText: hintText,
      hintStyle: hintStyle,
      filled: true,
      fillColor: fillColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
         containerBorderRadius,
        ),
        borderSide: BorderSide(color: enabledBorderColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
         containerBorderRadius,
        ),
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
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
        borderSide: BorderSide(color: focusedBorderColor, width: 0),
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
            left: 8,
            bottom: 8,
            right: 4,
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
                  text: 'place_order'.tr,
                  fontSize:subHeaderTFSize,
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
                      child: Obx(
                        () => InkWell(
                          onTap: () {
                            controller.showSalesItem.toggle();
                          },
                          child: Icon(
                            !controller.showSalesItem.value
                                ? TablerIcons.chevron_down
                                : TablerIcons.chevron_up,
                            size:closeIconSize,
                            color: colors.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    4.width,
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back(result: controller.salesItemList);
                        },
                        child: Icon(
                          TablerIcons.x,
                          size:closeIconSize,
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
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: FBString(
            isRequired: false,
            textController:
                controller.customerManager.searchTextController.value,
            onChange: (value) async {
              if (value?.isEmpty ?? true) {
                controller.customerManager.searchedItems.value = [];
                controller.customerManager.selectedItem.value = null;
                return;
              }
              await controller.customerManager.searchItemsByName(value!);
            },
            hint: appLocalization.searchCustomer,
            suffixIcon: TablerIcons.search,
          ),
        ),
        2.percentWidth,
        Expanded(
          child: GestureDetector(
            onTap: controller.addCustomer,
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
                    appLocalization.customer,
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
                    color: colors.evenListColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () {
                          return Text(
                            controller.salesSubTotal.value.toString(),
                            style: TextStyle(
                              fontSize:regularTFSize,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                        ),
                        width: Get.width * 0.1,
                        color: const Color(0xFFff3232),
                      ),
                      Text(
                        appLocalization.subTotal,
                        style: TextStyle(
                          fontSize:smallTFSize,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                     containerBorderRadius,
                    ),
                    color: colors.evenListColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () {
                          return Text(
                            controller.salesDiscount.value.toString(),
                            style: TextStyle(
                              fontSize:regularTFSize,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                        ),
                        width: Get.width * 0.1,
                        color: const Color(0xFFff3232),
                      ),
                      Text(
                        'discount'.tr,
                        style: TextStyle(
                          fontSize:smallTFSize,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                     containerBorderRadius,
                    ),
                    color: colors.evenListColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () {
                          return Text(
                            controller.salesVat.value.toString(),
                            style: TextStyle(
                              fontSize:regularTFSize,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                        ),
                        width: Get.width * 0.1,
                        color: const Color(0xFFff3232),
                      ),
                      Text(
                        'vat'.tr,
                        style: TextStyle(
                          fontSize:smallTFSize,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: colors.selectedColor,
                  ),
                  child: Column(
                    mainAxisAlignment: centerMAA,
                    children: [
                      Obx(
                        () => Text(
                          controller.netTotal.value.toString(),
                          style: TextStyle(
                            fontSize:regularTFSize,
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
                        'total'.tr,
                        style: TextStyle(
                          fontSize:smallTFSize,
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
          1.percentHeight,
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
                child: Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: AdvancedSwitch(
                      activeChild: Text('%'.tr),
                      inactiveChild: Text('flat'.tr),
                      activeColor: colors.successfulBaseColor,
                      inactiveColor: colors.dangerBaseColor,
                      borderRadius: BorderRadius.circular(
                       containerBorderRadius,
                      ),
                      width: Get.width * .226,
                      height:textFieldHeight,
                      controller: controller.discountTypeController.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: TextFormField(
                    controller: controller.paymentDiscountController.value,
                    cursorColor: colors.formCursorColor,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: buildInputDecoration(
                      hintText: 'discount'.tr,
                      hintStyle: TextStyle(
                        color: colors.formBaseHintTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize:regularTFSize,
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
                      fontSize:regularTFSize,
                    ),
                    onChanged: controller.onDiscountChange,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                          controller.salesReturnValue.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize:mediumTFSize,
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
                  height:textFieldHeight,
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
                      fontSize:regularTFSize,
                    ),
                    cursorColor: colors.formCursorColor,
                    decoration: buildInputDecoration(
                      hintText: 'amount'.tr,
                      hintStyle: TextStyle(
                        color: colors.formBaseHintTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize:regularTFSize,
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
        hint: 'select_user'.tr,
      ),
    );
  }

  Widget _buildProfitView(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(child: Container()),
        Expanded(child: Container()),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              left: 4,
              right: 4,
            ),
            child: AdvancedSwitch(
              activeChild: Text(
                'Yes'.tr,
                style: TextStyle(
                  color: colors.primaryTextColor,
                  fontSize:smallTFSize,
                ),
              ),
              inactiveChild: Text(
                'profit'.tr,
                style: TextStyle(
                  color: colors.primaryTextColor,
                  fontSize:smallTFSize,
                ),
              ),
              activeColor: colors.selectedColor,
              inactiveColor: colors.moduleHeaderColor,
              borderRadius: BorderRadius.circular(4),
              width: Get.width * .23,
              height: 3.ph,
              controller: controller.showProfit.value,
            ),
          ),
        ),
        Expanded(
          child: Container(
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
                fontSize:smallTFSize,
                textColor: colors.primaryBaseColor,
              ),
            ),
          ),
        ),
      ],
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
            buttonName: 'reset'.tr,
            onTap: () => controller.reset(context),
            leftIcon: TablerIcons.restore,
            buttonBGColor: colors.dangerLiteColor,
          ),
          4.width,
          RowButton(
            buttonName: 'hold'.tr,
            onTap: () => controller.hold(context),
            leftIcon: TablerIcons.progress,
            buttonBGColor: Colors.grey,
          ),
          4.width,
          RowButton(
            buttonName: 'order'.tr,
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
