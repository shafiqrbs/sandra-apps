import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/row_button.dart';
import '/app/global_widget/transaction_method_item_view.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/advance_select/advance_select_view.dart';
import '/app/core/base/base_view.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/list_button.dart';
import '/app/core/widget/quick_navigation_button.dart';
import 'add_particular_controller.dart';

//ignore: must_be_immutable
class AddParticularView extends BaseView<AddParticularController> {
  AddParticularView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AddParticularController>(
      init: AddParticularController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  AdvanceSelect(
                    isRequired: true,
                    controller: controller.userManager.asController,
                    hint: appLocalization.user,
                    isShowSearch: false,
                    itemToString: (data) => data?.username ?? '',
                    label: appLocalization.user,
                    errorMsg: 'user_required'.tr,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AdvanceSelect(
                          isRequired: true,
                          controller:
                              controller.expenseCategoryManager.asController,
                          hint: 'select_category'.tr,
                          isShowSearch: false,
                          itemToString: (data) => data?.name ?? '',
                          label: 'category'.tr,
                          errorMsg: 'category_required'.tr,
                        ),
                      ),
                      10.width,
                      Expanded(
                        child: FBString(
                          textController: controller.amountController.value,
                          keyboardType: numberInputType,
                          label: appLocalization.amount,
                          //example: 'sample_model'.tr,
                          hint: appLocalization.amount,
                          isRequired: true,
                          errorMsg: '',
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () {
                      return Column(
                        children: [
                          if (controller
                                  .transactionMethodsManager.allItems.value !=
                              null)
                            SingleChildScrollView(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 8,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                runSpacing: 8,
                                children: controller
                                    .transactionMethodsManager.allItems.value!
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
                      );
                    },
                  ),
                  FBString(
                    textController: controller.remarkController,
                    label: appLocalization.remark,
                    //example: 'sample_model'.tr,
                    hint: appLocalization.remark,
                    isRequired: false,
                    errorMsg: '',
                    lines: 4,
                  ),
                  Row(
                    children: [
                      RowButton(
                        buttonName: appLocalization.reset,
                        onTap: controller.onResetTap,
                        leftIcon: TablerIcons.restore,
                      ),
                      2.percentWidth,
                      RowButton(
                        buttonName: appLocalization.save,
                        onTap: controller.onSaveTap,
                        leftIcon: TablerIcons.device_floppy,
                      ),
                    ],
                  ),
                ],
              ),
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
