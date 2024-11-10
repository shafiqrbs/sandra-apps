import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/utils/responsive.dart';
import 'package:sandra/app/core/utils/style_function.dart';
import 'package:sandra/app/core/widget/app_bar_button_group.dart';
import 'package:sandra/app/core/widget/common_icon_text.dart';
import 'package:sandra/app/core/widget/common_text.dart';
import 'package:sandra/app/core/widget/label_value.dart';
import 'package:sandra/app/core/widget/list_button.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';
import 'package:sandra/app/core/widget/row_button.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/inventory/sales/sales_return_page/controllers/sales_return_page_controller.dart';

//ignore: must_be_immutable
class SalesReturnPageView extends BaseView<SalesReturnPageController> {
  SalesReturnPageView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: PageBackButton(
        pageTitle: appLocalization.salesReturnPageTitle,
      ),
      automaticallyImplyLeading: false,
      actions: [
        AppBarButtonGroup(
          children: [
            QuickNavigationButton(),
          ],
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
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
                          text: controller.sales.value?.customerName ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.file_invoice,
                          text: controller.sales.value?.invoice ?? '',
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
                          text: controller.sales.value?.customerMobile ?? '',
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
                          text: controller.sales.value?.createdAt ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.info_square_rounded,
                          text: controller.sales.value?.methodName ?? '',
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
            height: 40.ph,
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.sales.value?.salesItem?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final elementItem = controller.sales.value!.salesItem![index];
                  final qtyController = TextEditingController(
                    text: elementItem.quantity?.toString() ?? '',
                  );

                  final priceController = TextEditingController(
                    text: elementItem.mrpPrice?.toString() ?? '',
                  );

                  final total = (elementItem.subTotal?.toString() ?? 0).obs;

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
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            height: mediumTextFieldHeight,
                            //width: Get.width * 0.7,
                            color: colors.primaryColor50,
                            child: TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: doubleInputFormatter,
                              onChanged: (value) {
                                elementItem.mrpPrice =
                                    double.tryParse(value) ?? 0;
                                total.value = (elementItem.mrpPrice! *
                                        elementItem.quantity!)
                                    .toString();
                              },
                              style: TextStyle(
                                fontSize: mediumTFSize,
                                color: colors.solidBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              cursorColor: colors.solidBlackColor,
                              decoration: getInputDecoration(
                                hint: '%',
                              ),
                            ),
                          ),
                        ),
                        5.width,
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            height: mediumTextFieldHeight,
                            //width: Get.width * 0.7,
                            color: colors.primaryColor50,
                            child: TextFormField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: doubleInputFormatter,
                              onChanged: (value) {
                                elementItem.quantity =
                                    double.tryParse(value) ?? 0;
                                total.value = (elementItem.mrpPrice! *
                                        elementItem.quantity!)
                                    .toString();
                              },
                              style: TextStyle(
                                fontSize: mediumTFSize,
                                color: colors.solidBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              cursorColor: colors.solidBlackColor,
                              decoration: getInputDecoration(
                                hint: '%',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => CommonText(
                              text: total.value.toString(),
                              fontSize: mediumTFSize,
                              textColor: colors.solidBlackColor,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    appLocalization.totalReturnAmount,
                    style: TextStyle(
                      fontSize: mediumTFSize,
                      color: colors.primaryColor500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ' : ',
                    style: TextStyle(
                      fontSize: mediumTFSize,
                      color: colors.primaryColor500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ' ${controller.sales.value!.netTotal}',
                    style: TextStyle(
                      fontSize: mediumTFSize,
                      color: colors.primaryColor500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.width,
                ],
              ),
            ],
          ),
          10.height,
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(right: 16),
            margin: const EdgeInsets.only(bottom: 16),
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        height: mediumTextFieldHeight,
                        //width: Get.width * 0.7,
                        color: colors.whiteColor,
                        child: TextFormField(
                          controller: controller.paymentController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: doubleInputFormatter,
                          onChanged: (value) {},
                          style: TextStyle(
                            fontSize: mediumTFSize,
                            color: colors.solidBlackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: colors.solidBlackColor,
                          decoration: getInputDecoration(
                            hint: appLocalization.payment,
                          ),
                        ),
                      ),
                    ),
                    5.width,
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        height: mediumTextFieldHeight,
                        //width: Get.width * 0.7,
                        color: colors.whiteColor,
                        child: TextFormField(
                          controller: controller.adjustmentController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: doubleInputFormatter,
                          onChanged: (value) {},
                          style: TextStyle(
                            fontSize: mediumTFSize,
                            color: colors.solidBlackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: colors.solidBlackColor,
                          decoration: getInputDecoration(
                            hint: appLocalization.adjustment,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                10.height,
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  height: mediumTextFieldHeight,
                  //width: Get.width * 0.7,
                  color: colors.whiteColor,
                  child: TextFormField(
                    controller: controller.remarkController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: doubleInputFormatter,
                    onChanged: (value) {},
                    style: TextStyle(
                      fontSize: mediumTFSize,
                      color: colors.solidBlackColor,
                      fontWeight: FontWeight.w500,
                    ),
                    cursorColor: colors.solidBlackColor,
                    decoration: getInputDecoration(
                      hint: appLocalization.remark,
                    ),
                  ),
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RowButton(
                      buttonName: appLocalization.reset,
                      leftIcon: TablerIcons.restore,
                      onTap: controller.resetField,
                      isOutline: true,
                    ),
                    16.width,
                    RowButton(
                      buttonName: appLocalization.save,
                      leftIcon: TablerIcons.device_floppy,
                      onTap: controller.save,
                      isOutline: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}