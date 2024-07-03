import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:terminalbd/core/base_widget.dart';
import 'package:terminalbd/global_modal/common_confirmation_modal.dart';
import 'package:terminalbd/global_widget/common_icon_text.dart';
import 'package:terminalbd/global_widget/common_text.dart';
import 'package:terminalbd/global_widget/label_value.dart';
import 'package:terminalbd/model/sales.dart';
import 'package:terminalbd/pages/inventory/sales_edit_screen/sales_edit_controller.dart';
import 'package:terminalbd/pages/inventory/sales_edit_screen/sales_edit_screen.dart';
import 'package:terminalbd/utils/responsive.dart';

import 'sales_information_modal_controller.dart';

class SalesInformationModalView extends BaseWidget {
  final String salesMode;
  final Sales sales;
  final Function()? onDeleted;
  SalesInformationModalView({
    required this.salesMode,
    required this.sales,
    this.onDeleted,
    super.key,
  });

  LabelValue get labelValue => LabelValue(
        label: 'label',
        value: 'value',
        labelFontSize: mediumTFSize,
        valueFontSize: mediumTFSize,
        valueFlex: 1,
        labelFlex: 2,
        valueTextAlign: TextAlign.end,
        padding: EdgeInsets.zero,
      );

  @override
  Widget build(BuildContext context) {
    final mvc = Get.put(
      SalesInformationModalController(
        sales: sales,
        salesMode: salesMode,
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        color: colors.moduleBodyColor,
      ),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.moduleBodyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(containerBorderRadius),
                topRight: Radius.circular(
                  containerBorderRadius,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Column(
                children: [
                  // title
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.user,
                          text: mvc.sales.value!.customerName ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.file_invoice,
                          text: '${mvc.sales.value!.invoice}',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.device_mobile,
                          text: mvc.sales.value!.customerMobile ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.wallet,
                          text: '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.calendar,
                          text: mvc.sales.value!.createdAt ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.info_square_rounded,
                          text: mvc.sales.value!.process ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,

                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.clock_hour_3,
                          text: 'Time',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.user,
                          text: 'Not found',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: colors.primaryLiteColor.withOpacity(.5),
            ),
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: CommonText(
                    text: 'name'.tr,
                    fontSize: mediumTFSize,
                    textColor: colors.primaryTextColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: 'price'.tr,
                    fontSize: mediumTFSize,
                    textColor: colors.primaryTextColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: 'qty'.tr,
                    fontSize: mediumTFSize,
                    textColor: colors.primaryTextColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: 'total'.tr,
                    fontSize: mediumTFSize,
                    textColor: colors.primaryTextColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.ph,
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: mvc.sales.value?.salesItem?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final elementItem = mvc.sales.value!.salesItem![index];

                  return Container(
                    //height: 50,
                    width: Get.width,
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                      left: 16,
                      right: 16,
                    ),
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? colors.evenListColor
                          : colors.oddListColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: CommonText(
                            text:
                                '${index + 1}. ${elementItem.stockName ?? ''}',
                            fontSize: mediumTFSize,
                            textColor: colors.primaryTextColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            text: elementItem.mrpPrice?.toString() ?? '',
                            fontSize: mediumTFSize,
                            textColor: colors.primaryTextColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            text: elementItem.quantity?.toString() ?? '',
                            fontSize: mediumTFSize,
                            textColor: colors.primaryTextColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            text: elementItem.subTotal?.toString() ?? '',
                            fontSize: mediumTFSize,
                            textColor: colors.primaryTextColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 2,
            decoration: BoxDecoration(
              color: colors.moduleHeaderColor,
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                  //flex: 2,
                  child: Column(
                    mainAxisAlignment: endMAA,
                    crossAxisAlignment: endCAA,
                    children: [
                      labelValue.copyWith(
                        label: 'sub_total'.tr,
                        value: '${mvc.sales.value!.subTotal}',
                      ),
                      labelValue.copyWith(
                        label:
                            "${"discount".tr} (${mvc.sales.value!.discountCalculation})",
                        value: '${mvc.sales.value!.discount}',
                      ),
                      Container(
                        width: Get.width,
                        height: 2,
                        decoration: BoxDecoration(
                          color: colors.moduleHeaderColor,
                        ),
                      ),
                      labelValue.copyWith(
                        label: 'total'.tr,
                        value: '${mvc.sales.value!.netTotal}',
                      ),
                      labelValue.copyWith(
                        label: 'receive'.tr,
                        value: '${mvc.sales.value!.received}',
                      ),
                      Container(
                        width: Get.width,
                        height: 2,
                        decoration: BoxDecoration(
                          color: colors.moduleHeaderColor,
                        ),
                      ),
                      labelValue.copyWith(
                        label: 'due'.tr,
                        value: (
                          (mvc.sales.value!.netTotal!) -
                              (mvc.sales.value!.received ?? 0),
                        ).toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          16.height,
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {

                    await showDialog(
                      context: context,
                      builder: (context) {
                        return CommonConfirmationModal(
                          title: 'do_you_want_to_delete_this_sales?'.tr,
                        );
                      },
                    ).then(
                      (value) {
                        print('value: $value');
                        if (value) onDeleted?.call();
                      },
                    );
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        containerBorderRadius,
                      ),
                      color: colors.removeButtonFillColor,
                    ),
                    margin: const EdgeInsets.only(
                      left: 4,
                    ),
                    child: Center(
                      child: Icon(
                        TablerIcons.trash,
                        color: colors.removeButtonIconColor,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: mvc.salesMode == 'online' || mvc.salesMode == 'local',
                child: Expanded(
                  child: InkWell(
                    onTap: () => mvc.salesPrint(context),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: colors.iconBackgroundColor,
                      ),
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: const Center(
                        child: Icon(
                          TablerIcons.printer,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: mvc.salesMode == 'online' || mvc.salesMode == 'local',
                child: Expanded(
                  child: InkWell(
                    onTap: () {
                      if (Get.isRegistered<SalesEditController>()) {
                        Get.delete<SalesEditController>();
                      }
                      Get.to(
                        SalesEditScreen(
                          sales: sales,
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: colors.editButtonFillColor,
                      ),
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: Center(
                        child: Icon(
                          TablerIcons.pencil,
                          color: colors.editButtonIconColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => mvc.copySales(sales),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        containerBorderRadius,
                      ),
                      color: colors.selectedColor,
                    ),
                    margin: const EdgeInsets.only(
                      left: 4,
                    ),
                    child: const Center(child: Icon(TablerIcons.copy)),
                  ),
                ),
              ),
              Visibility(
                visible: mvc.salesMode == 'online' || mvc.salesMode == 'local',
                child: Expanded(
                  child: InkWell(
                    onTap: () {
                      //shareContent();
                      // Get.to(OnlineSalesInvoice(element: mvc.sales,));
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: colors.infoButtonFillColor,
                      ),
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: Center(
                        child: Icon(
                          TablerIcons.share,
                          color: colors.infoButtonIconColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: mvc.salesMode == 'online',
                child: Expanded(
                  child: InkWell(
                    onTap: () {
                      toast('Sales return is under development');
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: colors.primaryLiteColor,
                      ),
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: Center(
                        child: Icon(
                          TablerIcons.receipt_refund,
                          color: colors.editButtonIconColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              4.width,
            ],
          ),
          1.percentHeight,
        ],
      ),
    );
  }
}