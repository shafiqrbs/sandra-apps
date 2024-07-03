import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/base/base_view.dart';
import 'package:nb_utils/nb_utils.dart';

import 'receive_modal_controller.dart';

class ReceiveModalView extends BaseView<ReceiveModalController> {
  final Customer? customer;
  ReceiveModalView({
    required this.customer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mvc = Get.put(
      ReceiveModalController(
        customer: customer,
      ),
    );
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
              textController: mvc.customerManager.searchTextController.value,
              onChange: (value) async {
                if (value?.isEmpty ?? true) {
                  mvc.customerManager.searchedItems.value = [];
                  mvc.customerManager.selectedItem.value = null;
                  return;
                }
                await mvc.customerManager.searchItemsByName(value!);

                print('search: $value');
                //print('search: ${mvc.customerManager.allItems.value!.length}');
              },
              hint: 'search_customer'.tr,
              suffixIcon: TablerIcons.search,
            ),
            1.percentHeight,
            Stack(
              children: [
                Column(
                  children: [
                    Obx(
                      () => mvc.customerManager.selectedItem.value != null
                          ? Column(
                              children: [
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
                    ),
                    Obx(
                      () => Column(
                        children: [
                          1.percentHeight,
                          if (mvc.transactionMethodsManager.allItems.value !=
                              null)
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(8),
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 8,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                runSpacing: 8,
                                children: mvc
                                    .transactionMethodsManager.allItems.value!
                                    .map(
                                  (e) {
                                    final selected = mvc
                                        .transactionMethodsManager
                                        .selectedItem
                                        .value;
                                    return TransactionMethodItem(
                                      method: e,
                                      isSelected: selected == e,
                                      onTap: () {
                                        mvc.transactionMethodsManager
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
                        controller: mvc.amountController.value,
                        inputFormatters: [regexDouble],
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                        cursorColor: colors.formCursorColor,
                        decoration: InputDecoration(
                          hintText: 'Amount',
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
                      textController: mvc.addRemarkController.value,
                      isRequired: false,
                      lines: 2,
                      hint: 'add_remark'.tr,
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
                            buttonName: 'reset'.tr,
                            leftIcon: TablerIcons.restore,
                            onTap: mvc.resetField,
                            isOutline: true,
                          ),
                          16.width,
                          RowButton(
                            buttonName: 'save'.tr,
                            leftIcon: TablerIcons.device_floppy,
                            onTap: mvc.processReceive,
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
                    itemCount:
                        mvc.customerManager.searchedItems.value?.length ?? 0,
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
                ),
              ],
            ),
          ],
        ),
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
