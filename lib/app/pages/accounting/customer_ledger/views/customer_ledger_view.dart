import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/utils/style_function.dart';
import '/app/global_widget/customer_card_view.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/accounting/customer_ledger/controllers/customer_ledger_controller.dart';

//ignore: must_be_immutable
class CustomerLedgerView extends BaseView<CustomerLedgerController> {
  CustomerLedgerView({super.key});

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
                          controller.customerManager.searchTextController.value,
                      style: TextStyle(
                        fontSize: regularTFSize,
                        fontWeight: FontWeight.w400,
                        color: colors.solidBlackColor,
                      ),
                      cursorColor: colors.solidBlackColor,
                      onChanged: controller.searchCustomer,
                      decoration: inputDecorationAppbarSearch(
                        hint: appLocalization.searchCustomer,
                        textEditingController: controller
                            .customerManager.searchTextController.value,
                        isSHowSuffixIcon: controller.customerManager
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
                      onTap: () async {},
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
                          customerLedgerReport: controller.customerLedgerReport.value!,
                          customer: controller.customerManager.selectedItem.value!,
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
          () => CustomerCardView(
            data: controller.customerManager.selectedItem.value!,
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
                flex: 3,
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
                  appLocalization.sales,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  appLocalization.receive,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  appLocalization.balance,
                  textAlign: TextAlign.right,
                  style: headerTextStyle,
                ),
              ),
            ],
          ),
        ),
        Obx(
          () {
            if (controller.customerLedgerReport.value == null) {
              ElevatedButton(
                onPressed: () async {
                  await controller.fetchLedgerReport();
                },
                child: Text('Load Data'),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: controller.customerLedgerReport.value?.length ?? 0,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final data = controller.customerLedgerReport.value![index];
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.showSalesInformationModal(
                            context,
                            data,
                          );
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
                                flex: 3,
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
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomerSearchList() {
    return Obx(
      () {
        return Visibility(
          visible: controller.customerManager.searchedItems.value?.isNotEmpty ??
              false,
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
                    controller.customerManager.searchedItems.value?.length ?? 0,
                itemBuilder: (context, index) {
                  final data =
                      controller.customerManager.searchedItems.value?[index];
                  return CustomerCardView(
                    data: data!,
                    index: index,
                    onTap: () => controller.updateCustomer(data),
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
