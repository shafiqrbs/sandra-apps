import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/utils/style_function.dart';
import 'package:sandra/app/global_widget/vendor_card_view.dart';
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
      color: colors.selectedColor,
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
                  color: colors.textFieldColor,
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
                        color: colors.primaryTextColor,
                      ),
                      cursorColor: colors.formCursorColor,
                      onChanged: controller.searchCustomer,
                      decoration: inputDecorationAppbarSearch(
                        hint: appLocalization.searchCustomer,
                        textEditingController:
                            controller.vendorManager.searchTextController.value,
                        isSHowSuffixIcon: controller.vendorManager
                            .searchTextController.value.text.isNotEmpty,
                        suffix: InkWell(
                          onTap: controller.clearSearch,
                          child: Icon(
                            TablerIcons.x,
                            size: 18,
                            color: colors.formClearIconColor,
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
                      color: colors.selectedColor.withOpacity(.6),
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
                        color: colors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
                4.width,
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.selectedColor.withOpacity(.8),
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
                        color: colors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
                4.width,
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.selectedColor.withOpacity(.8),
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
                        TablerIcons.share_3,
                        color: colors.primaryTextColor,
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
          margin: const EdgeInsets.only(
            left: 4,
            right: 4,
          ),
          decoration: BoxDecoration(
            color: colors.primaryBaseColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'date'.tr,
                  textAlign: TextAlign.start,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'method'.tr,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'sales'.tr,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'receive'.tr,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'balance'.tr,
                  textAlign: TextAlign.center,
                  style: headerTextStyle,
                ),
              ),
            ],
          ),
        ),
        Obx(
          () {
            if (controller.vendorLedgerList.value == null) {
              ElevatedButton(
                onPressed: () async {
                  await controller.fetchLedgerReport();
                },
                child: Text('Load Data'),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: controller.vendorLedgerList.value?.length ?? 0,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final data = controller.vendorLedgerList.value![index];
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
                                ? colors.evenListColor
                                : colors.oddListColor,
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
                                  data.sales.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: mediumTFSize,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data.receive.toString(),
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
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: mediumTFSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? colors.evenListColor
                                : colors.oddListColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            TablerIcons.info_small,
                            size: 18,
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
                color: colors.evenListColor,
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
