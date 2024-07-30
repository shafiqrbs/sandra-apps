import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/widget/delete_button.dart';
import 'package:sandra/app/core/widget/no_record_found_view.dart';
import 'package:sandra/app/core/widget/retry_view.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/app_bar_search_view.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/search_button.dart';
import '/app/pages/accounting/accounting_purchase/controllers/accounting_purchase_controller.dart';

//ignore: must_be_immutable
class AccountingPurchaseView extends BaseView<AccountingPurchaseController> {
  AccountingPurchaseView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.accountPurchase,
            controller: controller.purchaseList.searchTextController.value,
            onSearch: controller.purchaseList.searchItemsByNameOnAllItem,
            onMicTap: controller.isSearchSelected.toggle,
            onFilterTap: () => controller.showFilterModal(
              context: globalKey.currentContext!,
            ),
            onClearTap: controller.onClearSearchText,
            showSearchView: controller.isSearchSelected.value,
          );
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        Obx(
          () {
            if (controller.isSearchSelected.value) {
              return Container();
            }
            return AppBarButtonGroup(
              children: [
                AddButton(
                  onTap: controller.showVendorPaymentModal,
                ),
                SearchButton(
                  onTap: controller.isSearchSelected.toggle,
                ),
                QuickNavigationButton(),
              ],
            );
          },
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
            final items = controller.purchaseList.allItems.value;

            Widget content;
            if (items == null) {
              content = RetryView(
                onRetry: controller.fetchPurchaseList,
              );
            } else if (items.isEmpty) {
              content = const NoRecordFoundView();
            } else {
              content = _buildListView();
            }

            return Expanded(
              child: content,
            );
          },
        ),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: controller.purchaseList.allItems.value!.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final element = controller.purchaseList.allItems.value![index];
        const iconColor = Color(0xff989898);

        return InkWell(
          onTap: () => controller.showSalesInformationModal(
            context,
            element,
          ),
          child: Container(
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
                        text: '{element.salesId}',
                        icon: TablerIcons.calendar_due,
                        iconColor: iconColor,
                      ),
                    ),
                    Expanded(
                      child: CommonIconText(
                        text: '{element.salesId}',
                        icon: TablerIcons.calendar,
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
                        text: element.balance?.toString() ?? '',
                        icon: TablerIcons.cash,
                        iconColor: iconColor,
                      ),
                    ),
                    Expanded(
                      child: CommonIconText(
                        text: element.vendorName ?? '',
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
                        text: element.vendorId?.toString() ?? '',
                        icon: TablerIcons.user,
                        iconColor: iconColor,
                      ),
                    ),
                    Expanded(
                      child: CommonIconText(
                        text: element.method ?? '',
                        icon: TablerIcons.user,
                        iconColor: iconColor,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: controller.approvePurchase,
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
                          DeleteButton(
                            onTap: controller.deletePurchase,
                          ),
                        ],
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
}
