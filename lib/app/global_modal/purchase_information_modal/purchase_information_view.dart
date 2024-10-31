import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import '/app/entity/purchase.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/common_confirmation_modal.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/label_value.dart';
import 'purchase_information_controller.dart';

class PurchaseInformationView extends BaseView<PurchaseInformationController> {
  final String purchaseMode;
  final Purchase purchase;
  final Function()? onDeleted;
  final bool? isShowFooter;
  PurchaseInformationView({
    required this.purchaseMode,
    required this.purchase,
    this.onDeleted,
    this.isShowFooter = true,
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
    return GetX<PurchaseInformationController>(
      init: PurchaseInformationController(
        purchase: purchase,
        purchaseMode: purchaseMode,
      ),
      builder: (controller) {
        final createdDate = controller.purchase.value!.createdAt != null
            ? DateFormat('dd MMM yyyy').format(
                DateFormat('MM-dd-yyyy hh:mm a')
                    .parse(controller.purchase.value!.createdAt!),
              )
            : '';
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
                              text: controller.purchase.value!.vendorName ?? '',
                              fontSize: mediumTFSize,
                            ),
                          ),
                          Expanded(
                            child: CommonIconText(
                              icon: TablerIcons.file_invoice,
                              text: '${controller.purchase.value!.invoice}',
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
                              text:
                                  controller.purchase.value!.vendorMobile ?? '',
                              fontSize: mediumTFSize,
                            ),
                          ),
                          Expanded(
                            child: CommonIconText(
                              icon: TablerIcons.wallet,
                              text: controller.purchase.value!.methodName ?? '',
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
                              text: createdDate ?? '',
                              fontSize: mediumTFSize,
                            ),
                          ),
                          Expanded(
                            child: CommonIconText(
                              icon: TablerIcons.user_heart,
                              text: controller.purchase.value!.createdBy ?? '',
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
                    itemCount:
                        controller.purchase.value?.purchaseItem?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final elementItem =
                          controller.purchase.value!.purchaseItem![index];

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
                              ? colors.secondaryColor50
                              : colors.primaryColor50,
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
                                textColor: colors.solidBlackColor,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              child: CommonText(
                                text: elementItem.price?.toString() ?? '',
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
                            value: '${controller.purchase.value!.subTotal}',
                          ),
                          labelValue.copyWith(
                            label:
                                "${appLocalization.discount} (${controller.purchase.value!.discountCalculation})",
                            value: '${controller.purchase.value!.discount}',
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
                            value: '${controller.purchase.value!.netTotal}',
                          ),
                          labelValue.copyWith(
                            label: appLocalization.received,
                            value: '${controller.purchase.value!.received}',
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
                              (controller.purchase.value!.netTotal ?? 0) -
                                  (controller.purchase.value!.received ?? 0),
                            ).toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isShowFooter! ? 16.height : 0.height,
              isShowFooter!
                  ? Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => controller.deletePurchase(
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
                        Visibility(
                          visible: controller.purchaseMode == 'online' ||
                              controller.purchaseMode == 'local',
                          child: Expanded(
                            child: InkWell(
                              onTap: () => controller.purchasePrint(context),
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
                          visible: controller.purchaseMode == 'online' ||
                              controller.purchaseMode == 'local',
                          child: Expanded(
                            child: InkWell(
                              onTap: controller.goToEditPurchase,
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
                            onTap: controller.copyPurchase,
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
                          visible: controller.purchaseMode == 'online' ||
                              controller.purchaseMode == 'local',
                          child: Expanded(
                            child: InkWell(
                              onTap: () {
                                toast('Sales return is under development');
                                //shareContent();
                                // Get.to(OnlineSalesInvoice(element: controller.sales,));
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
                          visible: controller.purchaseMode == 'online',
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
                    )
                  : Container(),
              1.percentHeight,
            ],
          ),
        );
      },
    );
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
