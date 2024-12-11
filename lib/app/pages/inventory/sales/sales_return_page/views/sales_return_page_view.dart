import 'package:flutter/foundation.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/utils/style_function.dart';
import 'package:sandra/app/core/widget/row_button.dart';

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
          if (kDebugMode)
            ElevatedButton(
              onPressed: () {
                controller.generatedList.forEach(
                  (key, value) {
                    if (kDebugMode) {
                      print('key $key');
                      print('qty : ${value.quantity}');
                      print('mrp : ${value.mrpPrice}');
                      print('subtotal : ${value.subTotal}');
                    }
                  },
                );
              },
              child: const Text('Print generated List'),
            ),

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

          //012400011
          SizedBox(
            height: 40.ph,
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.sales.value?.salesItem?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  // return _cardItem();
                  final elementItem = controller.sales.value!.salesItem![index];
                  final initialPrice = elementItem.mrpPrice ?? 0;
                  final initialQuantity = elementItem.quantity ?? 0;

                  final qtyController = TextEditingController();

                  final priceController = TextEditingController();

                  final total = '0'.obs;
                  final elementId = elementItem.stockId;

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
                          child: Column(
                            children: [
                              Text(
                                initialPrice.toString(),
                              ),
                              Container(
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
                                    final parsedPrice =
                                        double.tryParse(value) ?? 0.0;

                                    if (parsedPrice > initialPrice) {
                                      priceController.clear();
                                    }

                                    final qtyText = qtyController.text;
                                    final priceText = priceController.text;

                                    if (qtyText.isNotEmpty &&
                                        priceText.isNotEmpty) {
                                      final quantity =
                                          double.tryParse(qtyText) ?? 0.0;
                                      final price =
                                          double.tryParse(priceText) ?? 0.0;

                                      total.value =
                                          (quantity * price).toStringAsFixed(
                                        2,
                                      );

                                      final item = elementItem
                                        ..quantity = quantity
                                        ..salesPrice = price
                                        ..subTotal = double.tryParse(
                                          total.value,
                                        );
                                      controller.addItem(item);
                                    } else {
                                      total.value = '0';
                                      controller.removeItem(elementId);
                                    }
                                    total.refresh();
                                  },
                                  style: TextStyle(
                                    fontSize: mediumTFSize,
                                    color: colors.solidBlackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  cursorColor: colors.solidBlackColor,
                                  decoration: getInputDecoration(
                                    hint: appLocalization.price,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        5.width,
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                initialQuantity.toString(),
                              ),
                              Container(
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
                                    final parsedQuantity =
                                        double.tryParse(value) ?? 0.0;

                                    // Clear the input if the new quantity exceeds the initial quantity
                                    if (parsedQuantity > initialQuantity) {
                                      qtyController.clear();
                                    }

                                    // Calculate the total if both quantity and price fields are filled
                                    final qtyText = qtyController.text;
                                    final priceText = priceController.text;

                                    if (qtyText.isNotEmpty &&
                                        priceText.isNotEmpty) {
                                      final quantity =
                                          double.tryParse(qtyText) ?? 0.0;
                                      final price =
                                          double.tryParse(priceText) ?? 0.0;

                                      total.value =
                                          (quantity * price).toStringAsFixed(
                                        2,
                                      );
                                      final item = elementItem
                                        ..quantity = quantity
                                        ..salesPrice = price
                                        ..subTotal = double.tryParse(
                                          total.value,
                                        );
                                      controller.addItem(item);
                                    } else {
                                      total.value = '0';
                                      controller.removeItem(elementId);
                                    }

                                    // Refresh to update the UI
                                    total.refresh();
                                  },
                                  style: TextStyle(
                                    fontSize: mediumTFSize,
                                    color: colors.solidBlackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  cursorColor: colors.solidBlackColor,
                                  decoration: getInputDecoration(
                                    hint: appLocalization.qty,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              CommonText(
                                text: elementItem.subTotal.toString(),
                                fontSize: mediumTFSize,
                                textColor: colors.solidBlackColor,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.right,
                              ),
                              const Divider(),
                              Obx(
                                () => CommonText(
                                  text: total.value,
                                  fontSize: mediumTFSize,
                                  textColor: colors.solidBlackColor,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
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
                  Obx(
                    () => Text(
                      controller.totalReturnAmount.value ?? '',
                      style: TextStyle(
                        fontSize: mediumTFSize,
                        color: colors.primaryColor500,
                        fontWeight: FontWeight.w500,
                      ),
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
                      labelValueDefault.copyWith(
                        label: appLocalization.subTotal,
                        value: '${controller.sales.value!.subTotal}',
                      ),
                      labelValueDefault.copyWith(
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
                      labelValueDefault.copyWith(
                        label: appLocalization.total,
                        value: '${controller.sales.value!.netTotal}',
                      ),
                      labelValueDefault.copyWith(
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
                      labelValueDefault.copyWith(
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
