import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/advance_select/advance_select_view.dart';
import 'package:getx_template/app/core/widget/app_bar_button_group.dart';
import 'package:getx_template/app/core/widget/fb_string.dart';
import 'package:getx_template/app/core/widget/list_button.dart';
import 'package:getx_template/app/core/widget/quick_navigation_button.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/expense/create_expense/controllers/create_expense_controller.dart';

//ignore: must_be_immutable
class CreateExpenseView extends BaseView<CreateExpenseController> {
  CreateExpenseView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Text(
        'create_expense'.tr,
        style: TextStyle(
          color: colors.backgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        AppBarButtonGroup(
          children: [
            ListButton(
              onTap: controller.goToListPage,
            ),
            QuickNavigationButton(),
          ],
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AdvanceSelect(
            isRequired: true,
            controller: controller.userManager.asController,
            hint: 'select_category'.tr,
            isShowSearch: false,
            itemToString: (data) => data?.username ?? '',
            label: 'category'.tr,
            errorMsg: 'category_required'.tr,
          ),
          0.height,
          FBString(
            textController: controller.amountController,
            label: 'amount'.tr,
            //example: 'sample_model'.tr,
            hint: 'amount'.tr,
            isRequired: false,
            errorMsg: '',
          ),
        ],
      ),
    );
  }
}
