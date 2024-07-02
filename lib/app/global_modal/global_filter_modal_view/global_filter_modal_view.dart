import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_date_picker.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/global_widget/customer_card_view.dart';

import 'global_filter_modal_controller.dart';

class GlobalFilterModalView extends BaseView<GlobalFilterModalController> {
  GlobalFilterModalView({super.key});

  @override
  Widget build(BuildContext context) {
    final mvc = Get.put(
      GlobalFilterModalController(),
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
              onChange: mvc.onCustomerSearch,
              hint: 'search_customer'.tr,
              suffixIcon: TablerIcons.users,
            ),
            Stack(
              children: [
                Column(
                  children: [
                    1.percentHeight,
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
                    FBString(
                      isRequired: false,
                      textController: mvc.searchKeyword.value,
                      hint: 'enter_search_keyword'.tr,
                      suffixIcon: TablerIcons.search,
                    ),
                    1.percentHeight,
                    Row(
                      children: [
                        Expanded(
                          child: FBDatePicker(
                            isRequired: false,
                            textController: mvc.startDateController.value,
                            hint: 'start_date'.tr,
                            suffixIcon: TablerIcons.calendar,
                          ),
                        ),
                        2.percentWidth,
                        Expanded(
                          child: FBDatePicker(
                            isRequired: false,
                            textController: mvc.endDateController.value,
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
                          onTap: mvc.onClose,
                        ),
                        1.percentWidth,
                        RowButton(
                          buttonName: 'submit'.tr,
                          onTap: mvc.onSubmit,
                        ),
                      ],
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
    // TODO(saiful): implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO(saiful): implement body
    throw UnimplementedError();
  }
}
