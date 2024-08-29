import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/label_value.dart';
import '/app/entity/sales.dart';
import 'sales_information_modal_controller.dart';

class SalesInformationModalView
    extends BaseView<SalesInformationModalController> {
  final String salesMode;
  final Sales sales;
  final Function()? onDeleted;
  final bool? isShowFooter;
  SalesInformationModalView({
    required this.salesMode,
    required this.sales,
    this.onDeleted,
    this.isShowFooter,
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
    return GetX<SalesInformationModalController>(
        init: SalesInformationModalController(
          sales: sales,
          salesMode: salesMode,
        ),
        builder: (controller) {
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
                      top: 8,
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
                                text:
                                    controller.sales.value!.customerName ?? '',
                                fontSize: mediumTFSize,
                              ),
                            ),
                            Expanded(
                              child: CommonIconText(
                                icon: TablerIcons.file_invoice,
                                text: '${controller.sales.value!.invoice}',
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
                                text: controller.sales.value!.customerMobile ??
                                    '',
                                fontSize: mediumTFSize,
                              ),
                            ),
                            Expanded(
                              child: CommonIconText(
                                icon: TablerIcons.user,
                                text: controller.sales.value?.createdBy ?? '',
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
                                text: controller.sales.value!.createdAt ?? '',
                                fontSize: mediumTFSize,
                              ),
                            ),
                            Expanded(
                              child: CommonIconText(
                                icon: TablerIcons.info_square_rounded,
                                text: controller.sales.value!.methodName ?? '',
                                fontSize: mediumTFSize,
                              ),
                            ),
                          ],
                        ),
                        4.height,
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
                          text: appLocalization.name,
                          fontSize: mediumTFSize,
                          textColor: colors.primaryTextColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: appLocalization.price,
                          fontSize: mediumTFSize,
                          textColor: colors.primaryTextColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: appLocalization.qty,
                          fontSize: mediumTFSize,
                          textColor: colors.primaryTextColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: appLocalization.total,
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
                      itemCount: controller.sales.value?.salesItem?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final elementItem =
                            controller.sales.value!.salesItem![index];

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
                                  fontSize: 10,
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
                              label: appLocalization.subTotal,
                              value: '${controller.sales.value!.subTotal}',
                            ),
                            labelValue.copyWith(
                              label:
                                  '${appLocalization.discount} (${controller.sales.value!.discountCalculation})',
                              value: '${controller.sales.value!.discount}',
                            ),
                            Container(
                              width: Get.width,
                              height: 2,
                              decoration: BoxDecoration(
                                color: colors.moduleHeaderColor,
                              ),
                            ),
                            labelValue.copyWith(
                              label: appLocalization.total,
                              value: '${controller.sales.value!.netTotal}',
                            ),
                            labelValue.copyWith(
                              label: appLocalization.receive,
                              value: '${controller.sales.value!.received}',
                            ),
                            Container(
                              width: Get.width,
                              height: 2,
                              decoration: BoxDecoration(
                                color: colors.moduleHeaderColor,
                              ),
                            ),
                            labelValue.copyWith(
                              label: appLocalization.due,
                              value: (
                                (controller.sales.value!.netTotal ?? 0) -
                                    (controller.sales.value!.received ?? 0),
                              ).toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                16.height,
                if (isShowFooter ?? true)
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.deleteSales(
                            onDeleted: onDeleted,
                          ),
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
                        visible: controller.salesMode == 'online' ||
                            controller.salesMode == 'local',
                        child: Expanded(
                          child: InkWell(
                            onTap: () => controller.salesPrint(context),
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
                        visible: controller.salesMode == 'online' ||
                            controller.salesMode == 'local',
                        child: Expanded(
                          child: InkWell(
                            onTap: controller.goToEditSales,
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
                          onTap: () => controller.copySales(sales),
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
                        visible: controller.salesMode == 'online' ||
                            controller.salesMode == 'local',
                        child: Expanded(
                          child: InkWell(
                            onTap: () {
                              //shareContent();
                              // Get.to(OnlineSalesInvoice(element: controller.sales,));
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
                        visible: controller.salesMode == 'online',
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
        });
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
