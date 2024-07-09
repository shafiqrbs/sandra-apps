import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/entity/purchase.dart';
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
  PurchaseInformationView({
    required this.purchaseMode,
    required this.purchase,
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
    return GetX<PurchaseInformationController>(
      init: PurchaseInformationController(
        purchase: purchase,
        purchaseMode: purchaseMode,
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
                              text: controller.purchase.value!.createdAt ?? '',
                              fontSize: mediumTFSize,
                            ),
                          ),
                          Expanded(
                            child: CommonIconText(
                              icon: TablerIcons.info_square_rounded,
                              text: controller.purchase.value!.process ?? '',
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
                                text: elementItem.price?.toString() ?? '',
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
                            value: '${controller.purchase.value!.subTotal}',
                          ),
                          labelValue.copyWith(
                            label:
                                "${"discount".tr} (${controller.purchase.value!.purchaseId})",
                            value: '${controller.purchase.value!.vendorName}',
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
                            value: '${controller.purchase.value!.netTotal}',
                          ),
                          labelValue.copyWith(
                            label: 'receive'.tr,
                            value: '${controller.purchase.value!.received}',
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
                              (controller.purchase.value!.netTotal!) -
                                  (controller.purchase.value!.received ?? 0),
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
                    visible: controller.purchaseMode == 'online' ||
                        controller.purchaseMode == 'local',
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
                    visible: controller.purchaseMode == 'online' ||
                        controller.purchaseMode == 'local',
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
                      onTap: () => controller.copyPurchase(purchase),
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
                    visible: controller.purchaseMode == 'online' ||
                        controller.purchaseMode == 'local',
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
                    visible: controller.purchaseMode == 'online',
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
