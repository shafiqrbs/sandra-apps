import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:terminalbd/advance_select/advance_select_view.dart';
import 'package:terminalbd/core/base_widget.dart';
import 'package:terminalbd/global_modal/add_customer_modal/add_customer_modal_controller.dart';
import 'package:terminalbd/global_modal/add_customer_modal/add_customer_modal_view.dart';
import 'package:terminalbd/global_modal/sales_process_modal/sales_process_modal_controller.dart';
import 'package:terminalbd/global_widget/common_text.dart';
import 'package:terminalbd/global_widget/dialog_pattern.dart';
import 'package:terminalbd/global_widget/fb_string.dart';
import 'package:terminalbd/global_widget/row_button.dart';
import 'package:terminalbd/global_widget/sales_item_list_view.dart';
import 'package:terminalbd/global_widget/transaction_method_item.dart';
import 'package:terminalbd/model/customer.dart';
import 'package:terminalbd/model/sales.dart';
import 'package:terminalbd/model/sales_item.dart';
import 'package:terminalbd/model/user.dart';
import 'package:terminalbd/pages/domain/customer/views/customer_card_view.dart';
import 'package:terminalbd/utils/responsive.dart';

class SalesProcessModalView extends BaseWidget {
  final Sales? preSales;
  final List<SalesItem> salesItemList;
  SalesProcessModalView({
    required this.salesItemList,
    required this.preSales,
    super.key,
  });

  // Globally declared for modularity
  late final SalesProcessModalController mvc;

  @override
  Widget build(BuildContext context) {
    mvc = Get.put(
      SalesProcessModalController(
        salesItemList: List<SalesItem>.from(salesItemList),
        preSales: preSales,
      ),
    );

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black.withOpacity(.5),
      shadowColor: Colors.white.withOpacity(.8),
      elevation: 0,
      child: Center(
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(containerBorderRadius),
            color: colors.backgroundColor,
          ),
          child: Form(
            key: mvc.formKey,
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
        borderRadius: BorderRadius.circular(containerBorderRadius),
        borderSide: BorderSide(color: enabledBorderColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        borderSide: BorderSide(color: errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(containerBorderRadius),
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
                      child: Obx(
                        () => InkWell(
                          onTap: () {
                            mvc.showSalesItem.toggle();
                          },
                          child: Icon(
                            !mvc.showSalesItem.value
                                ? TablerIcons.chevron_down
                                : TablerIcons.chevron_up,
                            size: closeIconSize,
                            color: colors.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    4.width,
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back(result: mvc.salesItemList);
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
        Obx(
          () => Visibility(
            visible: mvc.showSalesItem.value,
            child: Obx(
              () => SalesItemListView(
                salesItems: mvc.salesItemList.value,
                onItemRemove: (int index) {
                  mvc.salesItemList.removeAt(index);
                  mvc.calculateAllSubtotal();
                },
                onQtyChange: (double onQtyChange, int index) {},
                onDiscountChange: (int onQtyChange, int index) {},
                onSalesPriceChange: (double onSalesPriceChange, int index) {},
              ),
            ),
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
            textController: mvc.customerManager.searchTextController.value,
            onChange: (value) async {
              if (value?.isEmpty ?? true) {
                mvc.customerManager.searchedItems.value = [];
                mvc.customerManager.selectedItem.value = null;
                return;
              }
              await mvc.customerManager.searchItemsByName(value!);
            },
            hint: 'search_customer'.tr,
            suffixIcon: TablerIcons.search,
          ),
        ),
        2.percentWidth,
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (Get.isRegistered<AddCustomerModalController>()) {
                Get.delete<AddCustomerModalController>();
              }
              showDialog<Customer?>(
                context: context,
                builder: (context) {
                  return DialogPattern(
                    title: 'title',
                    subTitle: 'subTitle',
                    child: AddCustomerModalView(),
                  );
                },
              ).then(
                (Customer? value) async {
                  if (value != null) {
                    mvc.updateCustomer(
                      value,
                    );
                  }
                },
              );
            },
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
                    'customer',
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
      () => mvc.customerManager.selectedItem.value != null
          ? Column(
              children: [
                1.percentHeight,
                CustomerCardView(
                  data: mvc.customerManager.selectedItem.value!,
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
      () => mvc.customerManager.searchedItems.value?.isNotEmpty ?? false
          ? Container(
              color: Colors.white,
              height: 40.ph,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: mvc.customerManager.searchedItems.value?.length ?? 0,
                itemBuilder: (context, index) {
                  return CustomerCardView(
                    data: mvc.customerManager.searchedItems.value![index],
                    index: index,
                    onTap: () {
                      mvc.updateCustomer(
                        mvc.customerManager.searchedItems.value![index],
                      );
                      //close keyboard
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
                            mvc.salesSubTotal.value.toString(),
                            style: TextStyle(
                              fontSize: regularTFSize,
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
                        'sub_total'.tr,
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
                            mvc.salesDiscount.value.toString(),
                            style: TextStyle(
                              fontSize: regularTFSize,
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
                            mvc.salesVat.value.toString(),
                            style: TextStyle(
                              fontSize: regularTFSize,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: colors.selectedColor,
                  ),
                  child: Column(
                    mainAxisAlignment: centerMAA,
                    children: [
                      Obx(
                        () => Text(
                          mvc.netTotal.value.toString(),
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
                        'total'.tr,
                        style: TextStyle(
                          fontSize: smallTFSize,
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
          if (mvc.transactionMethodsManager.allItems.value != null)
            SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                runSpacing: 8,
                children: mvc.transactionMethodsManager.allItems.value!.map(
                  (e) {
                    final selected =
                        mvc.transactionMethodsManager.selectedItem.value;
                    return TransactionMethodItem(
                      method: e,
                      isSelected: selected == e,
                      onTap: () {
                        mvc.transactionMethodsManager.selectedItem.value = e;
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
                      height: textFieldHeight,
                      controller: mvc.discountTypeController.value,
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
                    controller: mvc.paymentDiscountController.value,
                    cursorColor: colors.formCursorColor,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: buildInputDecoration(
                      hintText: 'discount'.tr,
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
                    inputFormatters: doubleInputFormatter,
                    keyboardType: numberInputType,
                    textAlign: centerTA,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: regularTFSize,
                    ),
                    onChanged: mvc.onDiscountChange,
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
                          mvc.salesReturnValue.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: mediumTFSize,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          mvc.returnMsg.value.tr,
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
                    controller: mvc.amountController.value,
                    inputFormatters: doubleInputFormatter,
                    textInputAction: doneInputAction,
                    onEditingComplete: () =>
                        mvc.showConfirmationDialog(context),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: regularTFSize,
                    ),
                    cursorColor: colors.formCursorColor,
                    decoration: buildInputDecoration(
                      hintText: 'amount'.tr,
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
                    onChanged: mvc.onAmountChange,
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
        controller: mvc.userManager.value.asController,
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
                  fontSize: smallTFSize,
                ),
              ),
              inactiveChild: Text(
                'profit'.tr,
                style: TextStyle(
                  color: colors.primaryTextColor,
                  fontSize: smallTFSize,
                ),
              ),
              activeColor: colors.selectedColor,
              inactiveColor: colors.moduleHeaderColor,
              borderRadius: BorderRadius.circular(4),
              width: Get.width * .23,
              height: 3.ph,
              controller: mvc.showProfit.value,
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
                text: mvc.showProfit.value.value
                    ? (mvc.netTotal.value - mvc.salesPurchasePrice.value)
                        .toPrecision(2)
                        .toString()
                    : '',
                fontWeight: FontWeight.w500,
                fontSize: smallTFSize,
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
            onTap: () => mvc.reset(context),
            leftIcon: TablerIcons.restore,
            buttonBGColor: colors.dangerLiteColor,
          ),
          4.width,
          RowButton(
            buttonName: 'hold'.tr,
            onTap: () => mvc.hold(context),
            leftIcon: TablerIcons.progress,
            buttonBGColor: Colors.grey,
          ),
          4.width,
          RowButton(
            buttonName: 'order'.tr,
            onTap: () => mvc.showConfirmationDialog(context),
            leftIcon: TablerIcons.device_floppy,
          ),
        ],
      ),
    );
  }
}
