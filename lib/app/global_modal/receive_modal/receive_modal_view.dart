import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/entity/customer.dart';
import '/app/global_widget/customer_card_view.dart';
import '/app/global_widget/transaction_method_item_view.dart';
import 'receive_modal_controller.dart';

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
                FBString(
                  isRequired: false,
                  textController:
                      controller.customerManager.searchTextController.value,
                  onChange: controller.onSearchCustomer,
                  hint: appLocalization.searchCustomer,
                  suffixIcon: TablerIcons.search,
                ),
                1.percentHeight,
                Stack(
                  children: [
                    Column(
                      children: [
                        Obx(
                          () => controller.customerManager.selectedItem.value !=
                                  null
                              ? Column(
                                  children: [
                                    CustomerCardView(
                                      data: controller
                                          .customerManager.selectedItem.value!,
                                      index: 0,
                                      onTap: () {},
                                      onReceive: () {},
                                      showReceiveButton: false,
                                    ),
                                    1.percentHeight,
                                  ],
                                )
                              : Container(),
                        ),
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          height: 50,
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
                              hintText: appLocalization.amount,
                              filled: true,
                              fillColor: colors.textFieldColor,
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
                        1.percentHeight,
                        FBString(
                          textController: controller.addRemarkController.value,
                          isRequired: false,
                          lines: 2,
                          hint: appLocalization.addRemark,
                        ),
                        1.percentHeight,
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.moduleFooterColor,
                          ),
                          //height: 100,
                          width: Get.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RowButton(
                                buttonName: appLocalization.reset,
                                leftIcon: TablerIcons.restore,
                                onTap: controller.resetField,
                                isOutline: true,
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
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller
                                .customerManager.searchedItems.value?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return CustomerCardView(
                            data: controller
                                .customerManager.searchedItems.value![index],
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
