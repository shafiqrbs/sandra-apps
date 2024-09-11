import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_view.dart';

import 'prefs_settings_modal_controller.dart';

class PrefsSettingsModalView extends BaseView<PrefsSettingsModalController> {
  PrefsSettingsModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<PrefsSettingsModalController>(
      init: PrefsSettingsModalController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dividerWidget(),
                    Row(
                      children: [
                        Icon(
                          TablerIcons.report_money,
                          color: colors.primaryBaseColor,
                          size: 24,
                        ),
                        8.width,
                        Text(
                          appLocalization.sales.toUpperCase(),
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.primaryBaseColor,
                          ),
                        ),
                      ],
                    ),
                    dividerWidget(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: spaceBetweenMAA,
                            children: [
                              Text(
                                appLocalization.salesOnlineOffline,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AdvancedSwitch(
                                controller: controller.isSalesOnline,
                                onChanged: (value) async {
                                  await controller.setSalesOnline(value);
                                },
                                borderRadius: BorderRadius.circular(4),
                                height: 20,
                                width: 40,
                                activeColor: colors.primaryBaseColor,
                                initialValue: controller.isSalesOnline.value,
                              ),
                            ],
                          ),
                          16.height,
                          Row(
                            mainAxisAlignment: spaceBetweenMAA,
                            children: [
                              Text(
                                appLocalization.salesAllowedWithoutPayment,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AdvancedSwitch(
                                controller: controller.isZeroSalesAllowed,
                                onChanged: (value) async {
                                  await controller.setZeroSalesAllowed(value);
                                },
                                borderRadius: BorderRadius.circular(4),
                                height: 20,
                                width: 40,
                                activeColor: colors.primaryBaseColor,
                                initialValue:
                                    controller.isZeroSalesAllowed.value,
                              ),
                            ],
                          ),
                          16.height,
                          Row(
                            mainAxisAlignment: spaceBetweenMAA,
                            children: [
                              Text(
                                appLocalization.autoSalesApproval,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AdvancedSwitch(
                                controller: controller.isSalesAutoApproved,
                                onChanged: (value) async {
                                  await controller.setSalesAutoApproved(value);
                                },
                                borderRadius: BorderRadius.circular(4),
                                height: 20,
                                width: 40,
                                activeColor: colors.primaryBaseColor,
                                initialValue:
                                    controller.isSalesAutoApproved.value,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dividerWidget(),
                    Row(
                      children: [
                        Icon(
                          TablerIcons.shopping_cart,
                          color: colors.primaryBaseColor,
                          size: 24,
                        ),
                        8.width,
                        Text(
                          appLocalization.purchase.toUpperCase(),
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.primaryBaseColor,
                          ),
                        ),
                      ],
                    ),
                    dividerWidget(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: spaceBetweenMAA,
                            children: [
                              Text(
                                appLocalization.purchaseOnlineOffline,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AdvancedSwitch(
                                controller: controller.isPurchaseOnline,
                                onChanged: (value) async {
                                  await controller.setPurchaseOnline(value);
                                },
                                borderRadius: BorderRadius.circular(4),
                                height: 20,
                                width: 40,
                                activeColor: colors.primaryBaseColor,
                                initialValue: controller.isPurchaseOnline.value,
                              ),
                            ],
                          ),
                          16.height,
                          Row(
                            mainAxisAlignment: spaceBetweenMAA,
                            children: [
                              Text(
                                appLocalization.autoPurchaseApproval,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AdvancedSwitch(
                                controller: controller.isPurchaseAutoApproved,
                                onChanged: (value) async {
                                  await controller
                                      .setPurchaseAutoApproved(value);
                                },
                                borderRadius: BorderRadius.circular(4),
                                height: 20,
                                width: 40,
                                activeColor: colors.primaryBaseColor,
                                initialValue:
                                    controller.isPurchaseAutoApproved.value,
                              ),
                            ],
                          ),
                          16.height,
                          Column(
                            children: [
                              _buildSettingButton(
                                text: appLocalization.purchaseConfig,
                                trailingIcon: TablerIcons.chevron_right,
                                isOpen: controller.buttons.value ==
                                    Buttons.purchase,
                                onTap: () {
                                  controller.changeButton(Buttons.purchase);
                                },
                              ),
                              if (controller.buttons.value == Buttons.purchase)
                                8.height,
                              if (controller.buttons.value == Buttons.purchase)
                                Container(
                                  color: Colors.white,
                                  width: Get.width,
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 16,
                                    bottom: 16,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Row(
                                          mainAxisAlignment: spaceBetweenMAA,
                                          children: [
                                            Text(
                                              appLocalization.totalPrice,
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            AdvancedSwitch(
                                              controller:
                                                  controller.isTotalPurchase,
                                              onChanged: (value) async {
                                                await controller
                                                    .setTotalPurchase(value);
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              height: 20,
                                              width: 40,
                                              activeColor:
                                                  colors.primaryBaseColor,
                                              initialValue: controller
                                                  .isTotalPurchase.value,
                                            ),
                                          ],
                                        ),
                                      ),
                                      16.height,
                                      _buildCustomRadioButton(
                                        title: appLocalization.purchaseWithMrp,
                                        isSelected:
                                            controller.selectedPurchase.value ==
                                                'purchase_with_mrp',
                                        onTap: () {
                                          controller.changePurchase(
                                              'purchase_with_mrp');
                                        },
                                      ),
                                      16.height,
                                      _buildCustomRadioButton(
                                        title: appLocalization.purchasePrice,
                                        isSelected:
                                            controller.selectedPurchase.value ==
                                                'purchase_price',
                                        onTap: () {
                                          controller
                                              .changePurchase('purchase_price');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                dividerWidget(),
                Row(
                  children: [
                    Icon(
                      TablerIcons.printer,
                      color: colors.primaryBaseColor,
                      size: 24,
                    ),
                    8.width,
                    Text(
                      appLocalization.printer.toUpperCase(),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors.primaryBaseColor,
                      ),
                    ),
                  ],
                ),
                dividerWidget(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: spaceBetweenMAA,
                        children: [
                          Text(
                            appLocalization.printer,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AdvancedSwitch(
                            controller: controller.isHasPrinter,
                            onChanged: (value) async {
                              await controller.setHasPrinter(value);
                            },
                            borderRadius: BorderRadius.circular(4),
                            height: 20,
                            width: 40,
                            activeColor: colors.primaryBaseColor,
                            initialValue: controller.isHasPrinter.value,
                          ),
                        ],
                      ),
                      16.height,
                      Column(
                        children: [
                          _buildSettingButton(
                            text: appLocalization.printPaperType,
                            //icon: TablerIcons.printer,
                            trailingIcon: TablerIcons.chevron_right,
                            isOpen: controller.buttons.value ==
                                Buttons.printPaperType,
                            onTap: () {
                              controller.changeButton(Buttons.printPaperType);
                            },
                          ),
                          if (controller.buttons.value !=
                              Buttons.printPaperType)
                            16.height,
                          if (controller.buttons.value ==
                              Buttons.printPaperType)
                            Container(
                              margin: const EdgeInsets.only(
                                top: 8,
                              ),
                              padding: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              color: Colors.white,
                              width: Get.width,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.printerTypeList.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      controller.printerTypeList[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 16,
                                    ),
                                    child: Obx(
                                      () {
                                        return _buildCustomRadioButton(
                                          title: item.value ?? '',
                                          isSelected:
                                              controller.printerType.value ==
                                                  item.value,
                                          onTap: () {
                                            controller
                                                .setPrinterType(item.value);
                                          },
                                        );
                                      },
                                    ),
                                  );

                                  return RadioListTile<String>(
                                    title: Text(
                                      item.value ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: colors.defaultFontColor,
                                      ),
                                    ),
                                    value: item.value ?? '',
                                    groupValue: controller.printerType.value,
                                    onChanged: controller.setPrinterType,
                                    activeColor: colors.primaryBaseColor,
                                    contentPadding: const EdgeInsets.only(
                                      left: 24,
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: spaceBetweenMAA,
                        children: [
                          Text(
                            appLocalization.printEndNewLine,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            height: textFieldHeight,
                            child: TextFormField(
                              controller: controller.printNewLineController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                controller.setPrinterNewLine(
                                    int.tryParse(value) ?? 0);
                              },
                              onFieldSubmitted: (value) {
                                controller.setPrinterNewLine(
                                    int.tryParse(value) ?? 0);
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '1',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: colors.secondaryTextColor,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                filled: true,
                                fillColor: colors.textFieldColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: colors.borderColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: colors.borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: colors.borderColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /*if (controller.printerType.value.isEmpty)
                        const CircularProgressIndicator()
                      else
                        DropdownButton<int>(
                          value: controller.printerNewLine.value,
                          items: controller.newLineList,
                          onChanged: (value) async {
                            if (value == null) return;
                            controller.setPrinterNewLine(value);
                          },
                        ),*/
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomRadioButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.primaryBaseColor,
              ),
            ),
            child: isSelected
                ? Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primaryBaseColor,
                    ),
                  )
                : Container(),
          ),
          16.width,
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget dividerWidget() {
    return Column(
      children: [
        12.height,
        Container(
          height: 1,
          color: colors.borderColor,
        ),
        12.height,
      ],
    );
  }

  Widget _buildSettingButton({
    IconData? icon,
    required String text,
    required IconData trailingIcon,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: colors.defaultFontColor,
              size: 24,
            ),
          if (icon != null) 8.width,
          Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            isOpen ? TablerIcons.chevron_down : trailingIcon,
            color: colors.defaultFontColor,
          ),
        ],
      ),
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
