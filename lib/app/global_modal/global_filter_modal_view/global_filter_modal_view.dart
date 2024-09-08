import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:sandra/app/entity/vendor.dart';
import 'package:sandra/app/global_widget/vendor_card_view.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_date_picker.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/entity/customer.dart';
import '/app/global_widget/customer_card_view.dart';
import 'global_filter_modal_controller.dart';

class GlobalFilterModalView extends BaseView<GlobalFilterModalController> {
  final bool? showCustomer;
  final bool? showVendor;
  GlobalFilterModalView({
    super.key,
    this.showCustomer = true,
    this.showVendor = false,
  });

  final startDateController = TextEditingController().obs;
  final endDateController = TextEditingController().obs;
  final searchKeyword = TextEditingController().obs;
  final customerManager = CustomerManager();
  final vendorManager = VendorManager();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
        ),
        child: Column(
          children: [
            if (showVendor!)
              FBString(
                isRequired: false,
                textController: vendorManager.searchTextController.value,
                onChange: onVendorSearch,
                hint: appLocalization.searchVendor,
                suffixIcon: TablerIcons.users,
              ),
            if (showCustomer!)
              FBString(
                isRequired: false,
                textController: customerManager.searchTextController.value,
                onChange: onCustomerSearch,
                hint: appLocalization.searchCustomer,
                suffixIcon: TablerIcons.users,
              ),
            Stack(
              children: [
                Column(
                  children: [
                    1.percentHeight,
                    Obx(
                      () => customerManager.selectedItem.value != null
                          ? Column(
                              children: [
                                CustomerCardView(
                                  data: customerManager.selectedItem.value!,
                                  index: 0,
                                  onTap: () {},
                                  onReceive: () {},
                                  showReceiveButton: false,
                                ),
                                1.percentHeight,
                              ],
                            )
                          : Container(),
                    ),
                    FBString(
                      isRequired: false,
                      textController: searchKeyword.value,
                      hint: appLocalization.searchKeyword,
                      suffixIcon: TablerIcons.search,
                    ),
                    1.percentHeight,
                    Row(
                      children: [
                        Expanded(
                          child: FBDatePicker(
                            isRequired: false,
                            textController: startDateController.value,
                            hint: appLocalization.startDate,
                            suffixIcon: TablerIcons.calendar,
                          ),
                        ),
                        2.percentWidth,
                        Expanded(
                          child: FBDatePicker(
                            isRequired: false,
                            textController: endDateController.value,
                            hint: appLocalization.endDate,
                            suffixIcon: TablerIcons.calendar,
                          ),
                        ),
                      ],
                    ),
                    1.percentHeight,
                    Row(
                      children: [
                        RowButton(
                          buttonName: appLocalization.close,
                          onTap: onClose,
                        ),
                        1.percentWidth,
                        RowButton(
                          buttonName: appLocalization.submit,
                          onTap: onSubmit,
                        ),
                      ],
                    ),
                  ],
                ),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: customerManager.searchedItems.value?.length ?? 0,
                    itemBuilder: (context, index) {
                      return CustomerCardView(
                        data: customerManager.searchedItems.value![index],
                        index: index,
                        onTap: () {
                          updateCustomer(
                            customerManager.searchedItems.value![index],
                          );
                          //close keyboard
                          FocusScope.of(context).unfocus();
                        },
                        onReceive: () {},
                        showReceiveButton: false,
                      );
                    },
                  ),
                ),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: vendorManager.searchedItems.value?.length ?? 0,
                    itemBuilder: (context, index) {
                      return VendorCardView(
                        data: vendorManager.searchedItems.value![index],
                        index: index,
                        onTap: () {
                          updateVendor(
                            vendorManager.searchedItems.value![index],
                          );
                          //close keyboard
                          FocusScope.of(context).unfocus();
                        },
                        onReceive: () {},
                        showReceiveButton: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _getValue(String text) => text.isEmpty ? null : text;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    throw UnimplementedError();
  }

  void onClose() {
    Get.back();
  }

  void onSubmit() {
    Get.back(
      result: {
        'start_date': _getValue(startDateController.value.text),
        'end_date': _getValue(endDateController.value.text),
        'customer': customerManager.selectedItem.value,
        'vendor': vendorManager.selectedItem.value,
        'search_keyword': _getValue(searchKeyword.value.text),
      },
    );
  }

  Future<void> updateCustomer(Customer? customer) async {
    if (customer != null) {
      customerManager.searchTextController.value.text = customer.name!;
      customerManager.searchedItems.value = null;
      customerManager.selectedItem.value = customer;
    }
  }

  Future<void> updateVendor(Vendor? vendor) async {
    if (vendor != null) {
      vendorManager.searchTextController.value.text = vendor.name!;
      vendorManager.searchedItems.value = null;
      vendorManager.selectedItem.value = vendor;
    }
  }

  Future<void> onCustomerSearch(String? value) async {
    if (value?.isEmpty ?? true) {
      customerManager.searchedItems.value = [];
      customerManager.selectedItem.value = null;
      return;
    }
    await customerManager.searchItemsByName(value!);
  }

  Future<void> onVendorSearch(String? value) async {
    if (value?.isEmpty ?? true) {
      vendorManager.searchedItems.value = [];
      vendorManager.selectedItem.value = null;
      return;
    }
    vendorManager.searchItemsByName(value!);
  }
}
