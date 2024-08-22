import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/logged_user.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/widget/common_icon_text.dart';
import 'package:sandra/app/core/widget/common_text.dart';
import 'package:sandra/app/core/widget/delete_button.dart';
import 'package:sandra/app/core/widget/no_record_found_view.dart';
import 'package:sandra/app/core/widget/retry_view.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/pages/accounting/expense/expense_list/controllers/expense_list_controller.dart';

//ignore: must_be_immutable
class ExpenseListView extends BaseView<ExpenseListController> {
  ExpenseListView({super.key});
  final currency = SetUp().currency ?? '';

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Text(
        appLocalization.expenseList,
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
            AddButton(
              onTap: controller.showAddExpenseModal,
            ),
            QuickNavigationButton(),
          ],
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            final items = controller.expenseList.value;

            Widget content;
            if (items == null) {
              content = RetryView(
                onRetry: () => controller.getExpenseList(),
              );
            } else if (items.isEmpty) {
              content = NoRecordFoundView();
            } else {
              content = _buildListView();
            }

            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getExpenseList();
                },
                child: content,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListView() {
    const iconColor = Color(0xff989898);

    return ListView.builder(
      itemCount: controller.expenseList.value?.length ?? 0,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        //check ranger is valid

        final element = controller.expenseList.value![index];
        final createdDate = element.created;
        return Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: index.isEven ? colors.evenListColor : colors.oddListColor,
            borderRadius: BorderRadius.circular(containerBorderRadius),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CommonIconText(
                      text: '${element.created}',
                      icon: TablerIcons.calendar_due,
                      iconColor: iconColor,
                    ),
                  ),
                  Expanded(
                    child: CommonIconText(
                      text: '${element.invoice}',
                      icon: TablerIcons.file_invoice,
                      iconColor: iconColor,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              10.height,
              Row(
                children: [
                  Expanded(
                    child: CommonIconText(
                      text: element.createdBy ?? '',
                      icon: TablerIcons.cash,
                      iconColor: iconColor,
                    ),
                  ),
                  Expanded(
                    child: CommonIconText(
                      text: element.amount ?? '',
                      icon: TablerIcons.tag,
                      iconColor: iconColor,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              10.height,
              Row(
                children: [
                  Expanded(
                    child: CommonIconText(
                      text: element.remark ?? '',
                      icon: TablerIcons.user_share,
                      iconColor: iconColor,
                    ),
                  ),
                  Expanded(
                    child: CommonIconText(
                      text: element.accountHead ?? '',
                      icon: TablerIcons.user,
                      iconColor: iconColor,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => controller.approveExpense(
                            expenseId: element.id!,
                          ),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryBaseColor,
                              borderRadius: BorderRadius.circular(
                                containerBorderRadius,
                              ),
                              border: Border.all(
                                color: colors.primaryBaseColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText(
                                  text: appLocalization.approve,
                                  fontWeight: FontWeight.w500,
                                  fontSize: mediumButtonTFSize,
                                  textColor: colors.backgroundColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(controller.isManager)
                          DeleteButton(
                          onTap: () => controller.deleteExpense(
                            expenseId: element.id!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
