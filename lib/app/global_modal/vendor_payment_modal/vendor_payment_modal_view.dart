import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/utils/style_function.dart';
import 'package:sandra/app/core/widget/common_text.dart';
import '/app/entity/vendor.dart';
import '/app/global_widget/vendor_card_view.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/entity/customer.dart';
import '/app/global_widget/customer_card_view.dart';
import '/app/global_widget/transaction_method_item_view.dart';
import 'vendor_payment_modal_controller.dart';

class VendorPaymentModalView extends BaseView<VendorPaymentModalController> {
  final Vendor? vendor;
  VendorPaymentModalView({
    required this.vendor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<VendorPaymentModalController>(
      init: VendorPaymentModalController(
        vendor: vendor,
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
                _buildCustomerSearch(context),
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
                      () => controller.vendorManager.searchedItems.value
                                  ?.isNotEmpty ??
                              false
                          ? Container(
                              color: Colors.white,
                              height: 35.ph,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.vendorManager
                                        .searchedItems.value?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return VendorCardView(
                                    data: controller.vendorManager.searchedItems
                                        .value![index],
                                    index: index,
                                    onTap: () {
                                      controller.updateCustomer(
                                        controller.vendorManager.searchedItems
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
                                  color: colors.primaryBaseColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: colors.borderColor,
                                  width: 2,
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
                text: appLocalization.donNotHaveAnAccount,
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
                  textColor: colors.primaryBaseColor,
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
