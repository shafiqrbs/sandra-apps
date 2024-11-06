import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/page_state.dart';
import 'package:sandra/app/core/widget/no_record_found_view.dart';
import 'package:sandra/app/core/widget/retry_view.dart';
import 'package:sandra/app/entity/vendor_ledger.dart';
import '/app/core/utils/style_function.dart';
import '/app/global_widget/vendor_card_view.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/vendor_ledger/controllers/vendor_ledger_controller.dart';

//ignore: must_be_immutable
class VendorLedgerView extends BaseView<VendorLedgerController> {
  VendorLedgerView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: Stack(
            children: [
              _buildCustomerLedgerReport(),
              _buildCustomerSearchList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      color: colors.primaryColor100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  left: 8,
                ),
                padding: EdgeInsets.zero,
                height: textFieldHeight,
                decoration: BoxDecoration(
                  color: colors.primaryColor50,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      4,
                    ),
                  ),
                ),
                child: Obx(
                  () {
                    return TextFormField(
                      controller:
                          controller.vendorManager.searchTextController.value,
                      style: TextStyle(
                        fontSize: regularTFSize,
                        fontWeight: FontWeight.w400,
                        color: colors.solidBlackColor,
                      ),
                      cursorColor: colors.solidBlackColor,
                      onChanged: controller.searchCustomer,
                      decoration: inputDecorationAppbarSearch(
                        hint: appLocalization.searchVendor,
                        textEditingController:
                            controller.vendorManager.searchTextController.value,
                        isSHowSuffixIcon: controller.vendorManager
                            .searchTextController.value.text.isNotEmpty,
                        suffix: InkWell(
                          onTap: controller.clearSearch,
                          child: Icon(
                            TablerIcons.x,
                            size: 18,
                            color: colors.solidRedColor,
                          ),
                        ),
                        onTap: () {},
                        isSHowPrefixIcon: true,
                        prefixOnTap: Get.back,
                        prefix: TablerIcons.chevron_left,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          4.width,
          Expanded(
            // flex: selectedStock == null ? 2 : 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primaryColor50,
                      borderRadius: BorderRadius.circular(
                        containerBorderRadius,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 8,
                      left: 4,
                      right: 4,
                    ),
                    child: InkWell(
                      onTap: controller.startVoiceSearch,
                      child: Icon(
                        TablerIcons.microphone,
                        color: colors.solidBlackColor,
                      ),
                    ),
                  ),
                ),
                4.width,
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primaryColor50,
                      borderRadius: BorderRadius.circular(
                        containerBorderRadius,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 8,
                      left: 4,
                      right: 4,
                    ),
                    child: InkWell(
                      onTap: () async {
                        await controller.printVendorLedger(
                          vendorLedgerReport:
                              controller.pagingController.value.itemList!,
                          vendor: controller.vendorManager.selectedItem.value!,
                        );
                      },
                      child: Icon(
                        TablerIcons.file_text,
                        color: colors.solidBlackColor,
                      ),
                    ),
                  ),
                ),
                4.width,
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primaryColor50,
                      borderRadius: BorderRadius.circular(
                        containerBorderRadius,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 8,
                      left: 4,
                      right: 4,
                    ),
                    child: InkWell(
                      onTap: () async {
                        await controller.createLedgerPdf(
                          vendorLedgerReport:
                              controller.pagingController.value.itemList!,
                          vendor: controller.vendorManager.selectedItem.value!,
                        );
                      },
                      child: Icon(
                        TablerIcons.share,
                        color: colors.solidBlackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerLedgerReport() {
    final TextStyle headerTextStyle = TextStyle(
      fontSize: mediumTFSize,
      color: Colors.white,
    );
    return Column(
      children: [
        Obx(
          () => VendorCardView(
            data: controller.vendorManager.selectedItem.value!,
            index: 0,
            onTap: () {},
            onReceive: controller.showReceiveModal,
            showReceiveButton: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8, right: 8),
          decoration: BoxDecoration(
            color: colors.primaryColor400,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  appLocalization.date,
                  textAlign: TextAlign.start,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  appLocalization.method,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  appLocalization.purchase,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  appLocalization.payment,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  appLocalization.balance,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
            ],
          ),
        ),
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
                child: PagedListView<int, VendorLedger>(
                  pagingController: controller.pagingController.value,
                  shrinkWrap: true,
                  builderDelegate: PagedChildBuilderDelegate<VendorLedger>(
                    itemBuilder: (context, item, index) {
                      final data = item;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              // toast('INVOICE DETAILS MODAL is under developement');
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 8,
                                bottom: 8,
                                top: 8,
                                right: 8,
                              ),
                              margin: const EdgeInsets.only(
                                left: 4,
                                right: 4,
                              ),
                              decoration: BoxDecoration(
                                color: index.isEven
                                    ? colors.whiteColor
                                    : colors.primaryColor50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "${index + 1}. ${DateFormat("dd-M-yy").format(
                                        DateTime.now(),
                                      )}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: mediumTFSize,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      data.method ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: mediumTFSize,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      data.total.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: mediumTFSize,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      data.amount.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: mediumTFSize,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      data.balance.toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: mediumTFSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    newPageErrorIndicatorBuilder: (context) {
                      return listViewRetryView(
                        onRetry: controller
                            .pagingController.value.retryLastFailedRequest,
                      );
                    },
                  ),
                ),
              );
            }

            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildCustomerSearchList() {
    return Obx(
      () {
        return Visibility(
          visible:
              controller.vendorManager.searchedItems.value?.isNotEmpty ?? false,
          child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  containerBorderRadius,
                ),
                color: colors.secondaryColor50,
              ),
              child: ListView.builder(
                itemCount:
                    controller.vendorManager.searchedItems.value?.length ?? 0,
                itemBuilder: (context, index) {
                  final data =
                      controller.vendorManager.searchedItems.value?[index];
                  return VendorCardView(
                    data: data!,
                    index: index,
                    onTap: () => controller.updateVendor(data),
                    onReceive: () {},
                    showReceiveButton: true,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
