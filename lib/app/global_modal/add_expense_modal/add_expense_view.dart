import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';

import '/app/core/advance_select/advance_select_view.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/row_button.dart';
import '/app/global_widget/transaction_method_item_view.dart';
import 'add_expense_controller.dart';

//ignore: must_be_immutable
class AddExpenseView extends BaseView<AddExpenseController> {
  AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AddExpenseController>(
      init: AddExpenseController(),
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
                    errorMsg: appLocalization.userRequired,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AdvanceSelect(
                          isRequired: true,
                          controller:
                              controller.expenseCategoryManager.asController,
                          hint: appLocalization.selectCategory,
                          isShowSearch: false,
                          itemToString: (data) => data?.name ?? '',
                          label: appLocalization.category,
                          errorMsg: appLocalization.categoryRequired,
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
                            cursorColor: colors.solidBlackColor,
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

  InputDecoration buildInputDecoration({
    required String hintText,
    required TextStyle hintStyle,
    required Color fillColor,
    required Color enabledBorderColor,
    required Color focusedBorderColor,
    required Color errorBorderColor,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 8,
          ),
      hintText: hintText,
      hintStyle: hintStyle,
      filled: true,
      fillColor: fillColor,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        borderSide: BorderSide(
          color: enabledBorderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        borderSide: BorderSide(
          color: focusedBorderColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        borderSide: BorderSide(color: errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 0,
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
