import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/values/text_styles.dart';

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
              color: colors.secondaryColor50,
            ),
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.secondaryColor50,
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
                    color: colors.primaryColor50,
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
                          textColor: colors.solidBlackColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: appLocalization.price,
                          fontSize: mediumTFSize,
                          textColor: colors.solidBlackColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: appLocalization.qty,
                          fontSize: mediumTFSize,
                          textColor: colors.solidBlackColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: appLocalization.total,
                          fontSize: mediumTFSize,
                          textColor: colors.solidBlackColor,
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
                                ? colors.whiteColor
                                : colors.secondaryColor50,
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
                                  textColor: colors.solidBlackColor,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: CommonText(
                                  text: elementItem.mrpPrice?.toString() ?? '',
                                  fontSize: mediumTFSize,
                                  textColor: colors.solidBlackColor,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: CommonText(
                                  text: elementItem.quantity?.toString() ?? '',
                                  fontSize: mediumTFSize,
                                  textColor: colors.solidBlackColor,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: CommonText(
                                  text: elementItem.subTotal?.toString() ?? '',
                                  fontSize: mediumTFSize,
                                  textColor: colors.solidBlackColor,
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
                    color: colors.primaryColor50,
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
                                color: colors.primaryColor50,
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
                                color: colors.primaryColor50,
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
                      Visibility(
                        visible: controller.sales.value?.approvedBy == null &&
                            controller.isManager,
                        child: Expanded(
                          child: InkWell(
                            onTap: () => controller.deleteSales(
                              onDeleted: onDeleted,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  containerBorderRadius,
                                ),
                                color: colors.secondaryRedColor,
                              ),
                              margin: const EdgeInsets.only(
                                left: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 6,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      TablerIcons.trash,
                                      color: colors.solidBlackColor,
                                      size: 18,
                                    ),
                                    2.height,
                                    Text(
                                      appLocalization.delete,
                                      style: AppTextStyle.h4TextStyle400,
                                    ),
                                  ],
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
                            onTap: () => controller.salesPrint(context),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  containerBorderRadius,
                                ),
                                color: colors.secondaryBlueColor,
                              ),
                              margin: const EdgeInsets.only(
                                left: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 6,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      TablerIcons.printer,
                                      color: colors.solidBlackColor,
                                      size: 18,
                                    ),
                                    2.height,
                                    Text(
                                      appLocalization.print,
                                      style: AppTextStyle.h4TextStyle400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (controller.salesMode == 'online' ||
                                controller.salesMode == 'local') &&
                            controller.sales.value?.approvedBy == null &&
                            controller.isManager,
                        child: Expanded(
                          child: InkWell(
                            onTap: controller.goToEditSales,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  containerBorderRadius,
                                ),
                                color: colors.secondaryGreenColor,
                              ),
                              margin: const EdgeInsets.only(
                                left: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 6,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      TablerIcons.pencil,
                                      color: colors.solidBlackColor,
                                      size: 18,
                                    ),
                                    2.height,
                                    Text(
                                      appLocalization.edit,
                                      style: AppTextStyle.h4TextStyle400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: controller.copySales,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                containerBorderRadius,
                              ),
                              color: colors.solidOliveColor.withOpacity(.2),
                            ),
                            margin: const EdgeInsets.only(
                              left: 4,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    TablerIcons.copy,
                                    size: 18,
                                    color: colors.solidBlackColor,
                                  ),
                                  2.height,
                                  Text(
                                    appLocalization.copy,
                                    style: AppTextStyle.h4TextStyle400,
                                  ),
                                ],
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  containerBorderRadius,
                                ),
                                color: colors.solidPurpleColor.withOpacity(.2),
                              ),
                              margin: const EdgeInsets.only(
                                left: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 6,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      TablerIcons.receipt_refund,
                                      color: colors.solidBlackColor,
                                      size: 18,
                                    ),
                                    2.height,
                                    Text(
                                      appLocalization.returnn,
                                      style: AppTextStyle.h4TextStyle400,
                                    ),
                                  ],
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
                            onTap: () {
                              controller.createSalesDetailsPdf(
                                sales: controller.sales.value!,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  containerBorderRadius,
                                ),
                                color: colors.secondaryGreyColor,
                              ),
                              margin: const EdgeInsets.only(
                                left: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 6,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      TablerIcons.share,
                                      color: colors.solidBlackColor,
                                      size: 18,
                                    ),
                                    2.height,
                                    Text(
                                      appLocalization.share,
                                      style: AppTextStyle.h4TextStyle400,
                                    ),
                                  ],
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
