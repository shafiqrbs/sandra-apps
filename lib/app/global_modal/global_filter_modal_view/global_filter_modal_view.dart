import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/model/customer.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_date_picker.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/global_widget/customer_card_view.dart';

import 'global_filter_modal_controller.dart';

class GlobalFilterModalView extends BaseView<GlobalFilterModalController> {
  GlobalFilterModalView({super.key});

  final startDateController = TextEditingController().obs;
  final endDateController = TextEditingController().obs;
  final searchKeyword = TextEditingController().obs;
  final customerManager = CustomerManager();

  @override
  Widget build(BuildContext context) {
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
              textController: customerManager.searchTextController.value,
              onChange: onCustomerSearch,
              hint: 'search_customer'.tr,
              suffixIcon: TablerIcons.users,
            ),
            Stack(
              children: [
                Column(
                  children: [
                    1.percentHeight,
                    Obx(
                      () => customerManager.selectedItem.value != null
                          ? Column(
                              children: [
                                CustomerCardView(
                                  data: customerManager.selectedItem.value!,
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
                    FBString(
                      isRequired: false,
                      textController: searchKeyword.value,
                      hint: 'enter_search_keyword'.tr,
                      suffixIcon: TablerIcons.search,
                    ),
                    1.percentHeight,
                    Row(
                      children: [
                        Expanded(
                          child: FBDatePicker(
                            isRequired: false,
                            textController: startDateController.value,
                            hint: 'start_date'.tr,
                            suffixIcon: TablerIcons.calendar,
                          ),
                        ),
                        2.percentWidth,
                        Expanded(
                          child: FBDatePicker(
                            isRequired: false,
                            textController: endDateController.value,
                            hint: 'end_date'.tr,
                            suffixIcon: TablerIcons.calendar,
                          ),
                        ),
                      ],
                    ),
                    1.percentHeight,
                    Row(
                      children: [
                        RowButton(
                          buttonName: 'close'.tr,
                          onTap: onClose,
                        ),
                        1.percentWidth,
                        RowButton(
                          buttonName: 'submit'.tr,
                          onTap: onSubmit,
                        ),
                      ],
                    ),
                  ],
                ),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: customerManager.searchedItems.value?.length ?? 0,
                    itemBuilder: (context, index) {
                      return CustomerCardView(
                        data: customerManager.searchedItems.value![index],
                        index: index,
                        onTap: () {
                          updateCustomer(
                            customerManager.searchedItems.value![index],
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
    // TODO(saiful): implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO(saiful): implement body
    throw UnimplementedError();
  }

  void onClose() {
    Get.back();
  }

  void onSubmit() {
    Get.back(
      result: {
        'start_date': startDateController.value.text,
        'end_date': endDateController.value.text,
        'customer': customerManager.selectedItem.value,
        'search_keyword': searchKeyword.value.text,
      },
    );
  }

  Future<void> updateCustomer(Customer? customer) async {
    if (customer != null) {
      customerManager.searchTextController.value.text = customer.name!;
      customerManager.searchedItems.value = null;
      customerManager.selectedItem.value = customer;
    }
  }

  Future<void> onCustomerSearch(String? value) async {
    if (value?.isEmpty ?? true) {
      customerManager.searchedItems.value = [];
      customerManager.selectedItem.value = null;
      return;
    }
    await customerManager.searchItemsByName(value!);
  }
}
