import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/page_state.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/entity/vendor_ledger.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/app_bar_search_view.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/delete_button.dart';
import '/app/core/widget/no_record_found_view.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/retry_view.dart';
import '/app/core/widget/search_button.dart';
import '/app/pages/accounting/accounting_purchase/controllers/accounting_purchase_controller.dart';

//ignore: must_be_immutable
class AccountingPurchaseView extends BaseView<AccountingPurchaseController> {
  AccountingPurchaseView({super.key});
  final currency = SetUp().symbol ?? '';

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.accountPurchase,
            controller: controller.searchTextController.value,
            onSearch: controller.onSearch,
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
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: appBar(context),
      body: Column(
        children: [
          Obx(
            () {
              final pageState = controller.pageState;
              if (pageState == PageState.loading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: loaderColor,
                    ),
                  ),
                );
              }

              if (pageState == PageState.failed) {
                return RetryView(
                  onRetry: controller.refreshData,
                );
              }

              if (pageState == PageState.success) {
                final items = controller.pagingController.value.itemList;

                final isEmpty = items?.isEmpty ?? true;
                if (isEmpty) {
                  return NoRecordFoundView(
                    onTap: controller.refreshData,
                  );
                }

                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshData,
                    child: _buildListView(),
                  ),
                );
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return PagedListView<int, VendorLedger>(
      pagingController: controller.pagingController.value,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<VendorLedger>(
        itemBuilder: (context, item, index) {
          return _buildCardView(
            element: item,
            index: index,
            context: context,
          );
        },
        newPageErrorIndicatorBuilder: (context) {
          return listViewRetryView(
            onRetry: controller.pagingController.value.retryLastFailedRequest,
          );
        },
      ),
    );
  }

  Widget _buildCardView({
    required VendorLedger element,
    required int index,
    required BuildContext context,
  }) {
    final createdDate = element.created != null
        ? DateFormat('dd MMM yyyy').format(
            DateFormat('MM-dd-yyyy hh:mm a').parse(element.created!),
          )
        : '';
    return InkWell(
      onTap: () => controller.showPurchaseInformationModal(
        context,
        element,
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
          top: index == 0 ? 8 : 0,
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: index.isEven ? colors.evenListColor : colors.oddListColor,
                borderRadius: BorderRadius.circular(containerBorderRadius),
                border: Border.all(
                  color: colors.tertiaryBaseColor,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          text: createdDate,
                          icon: TablerIcons.calendar_due,
                          fontSize: valueTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          text: '${element.invoice}',
                          icon: TablerIcons.file_invoice,
                          fontSize: valueTFSize,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          text: element.name ?? '',
                          icon: TablerIcons.user,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: valueTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          text: element.method ?? 'N/A',
                          icon: TablerIcons.paywall,
                          fontSize: valueTFSize,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          text: element.mobile ?? '',
                          icon: TablerIcons.device_mobile,
                          fontSize: valueTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          text: element.approvedBy ?? '',
                          icon: TablerIcons.user_heart,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: valueTFSize,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 0.4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 4),
                          child: CommonText(
                            text:
                                '${appLocalization.total} : $currency ${element.total ?? ''}',
                            fontSize: valueTFSize,
                            textColor: colors.primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 4),
                          child: CommonText(
                            text:
                                '${appLocalization.amount} : $currency ${element.amount ?? ''}',
                            fontSize: valueTFSize,
                            textColor: colors.primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 4),
                          child: CommonText(
                            text:
                                "${appLocalization.due} :$currency ${element.balance ?? ""}",
                            fontSize: valueTFSize,
                            textColor: colors.primaryTextColor,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (element.approvedBy == null)
              if (controller.isManager)
                Positioned(
                  right: 0,
                  top: 4,
                  child: DeleteButton(
                    onTap: () => controller.deletePurchase(
                      element.id!,
                    ),
                  ),
                ),
            if (element.approvedBy == null)
              Positioned(
                right: 0,
                top: 34,
                child: IconButton(
                  onPressed: () => controller.approvePurchase(
                    purchaseId: element.id!,
                    index: index,
                  ),
                  icon: Icon(
                    TablerIcons.check,
                    color: colors.successfulBaseColor,
                  ),
                ),
              ),
            if (element.sourceInvoice != null)
              Positioned(
                right: 10,
                bottom: 8,
                child: GestureDetector(
                  onTap: () => controller.showPurchaseInformationModal(
                    context,
                    element,
                  ),
                  child: Icon(
                    TablerIcons.eye,
                    color: colors.primaryBaseColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
