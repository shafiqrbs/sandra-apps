import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/advance_select/advance_select_view.dart';
import '/app/core/base/base_view.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/list_button.dart';
import '/app/core/widget/quick_navigation_button.dart';
import 'add_expense_controller.dart';

//ignore: must_be_immutable
class AddExpenseView extends BaseView<AddExpenseController> {
  AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            AdvanceSelect(
              isRequired: true,
              controller: controller.userManager.asController,
              hint: 'user'.tr,
              isShowSearch: false,
              itemToString: (data) => data?.username ?? '',
              label: 'user'.tr,
              errorMsg: 'user_required'.tr,
            ),
            AdvanceSelect(
              isRequired: true,
              controller: controller.expenseCategoryManager.asController,
              hint: 'select_category'.tr,
              isShowSearch: false,
              itemToString: (data) => data?.name ?? '',
              label: 'category'.tr,
              errorMsg: 'category_required'.tr,
            ),
            FBString(
              textController: controller.amountController,
              label: 'amount'.tr,
              //example: 'sample_model'.tr,
              hint: 'amount'.tr,
              isRequired: false,
              errorMsg: '',
            ),
            FBString(
              textController: controller.remarkController,
              label: 'remark'.tr,
              //example: 'sample_model'.tr,
              hint: 'remark'.tr,
              isRequired: false,
              errorMsg: '',
              lines: 4,
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
