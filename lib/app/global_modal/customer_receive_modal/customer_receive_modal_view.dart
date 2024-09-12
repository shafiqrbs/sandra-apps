import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/common_text.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/entity/customer.dart';
import '/app/global_widget/customer_card_view.dart';
import '/app/global_widget/transaction_method_item_view.dart';
import 'customer_receive_modal_controller.dart';

class CustomerReceiveModalView
    extends BaseView<CustomerReceiveModalController> {
  final Customer? customer;
  CustomerReceiveModalView({
    required this.customer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<CustomerReceiveModalController>(
      init: CustomerReceiveModalController(
        customer: customer,
      ),
      builder: (controller) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.backgroundColor,
            ),
            child: Column(
              children: [
                Obx(() => _buildCustomerSearch(context)),
                Stack(
                  children: [
                    Column(
                      children: [
                        Obx(
                          () => Column(
                            children: [
                              1.percentHeight,
                              if (controller.transactionMethodsManager.allItems
                                      .value !=
                                  null)
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(8),
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    spacing: 8,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    runSpacing: 8,
                                    children: controller
                                        .transactionMethodsManager
                                        .allItems
                                        .value!
                                        .map(
                                      (e) {
                                        final selected = controller
                                            .transactionMethodsManager
                                            .selectedItem
                                            .value;
                                        return TransactionMethodItemView(
                                          method: e,
                                          isSelected: selected == e,
                                          onTap: () {
                                            controller.transactionMethodsManager
                                                .selectedItem.value = e;
                                          },
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        1.percentHeight,
                        FBString(
                          textController: controller.addRemarkController.value,
                          isRequired: false,
                          lines: 2,
                          hint: appLocalization.addRemark,
                        ),
                        1.percentHeight,
                      ],
                    ),
                    Obx(
                      () => controller.customerManager.searchedItems.value
                                  ?.isNotEmpty ??
                              false
                          ? Container(
                              color: Colors.white,
                              height: 35.ph,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.customerManager
                                        .searchedItems.value?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return CustomerCardView(
                                    data: controller.customerManager
                                        .searchedItems.value![index],
                                    index: index,
                                    onTap: () {
                                      controller.updateCustomer(
                                        controller.customerManager.searchedItems
                                            .value![index],
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
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  //height: 100,
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CommonText(text: appLocalization.sms),
                            8.width,
                            AdvancedSwitch(
                              controller: controller.isSms,
                              onChanged: (value) async {

                              },
                              borderRadius: BorderRadius.circular(4),
                              height: 20,
                              width: 40,
                              activeColor: colors.primaryColor700,
                              inactiveColor: colors.secondaryColor100,
                              initialValue: controller.isSms.value,
                            ),
                          ],
                        ),
                      ),
                      16.width,
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: 5.ph,
                          child: TextFormField(
                            controller: controller.amountController.value,
                            inputFormatters: [regexDouble],
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                            cursorColor: colors.formCursorColor,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: appLocalization.amount,
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: colors.primaryColor200,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: colors.primaryColor500,
                                ),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      16.width,
                      RowButton(
                        buttonName: appLocalization.save,
                        leftIcon: TablerIcons.device_floppy,
                        onTap: controller.processReceive,
                        isOutline: false,
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



  Widget _buildCustomerSearch(
    BuildContext context,
  ) {
    return Container(
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
                                        controller.customerManager.searchedItems
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
                                onPressed: controller.addCustomer,
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
                      if (value.isEmpty) {
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
                  textColor: colors.primaryColor500,
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

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
}
