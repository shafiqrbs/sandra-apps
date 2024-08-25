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
                Row(
                  mainAxisAlignment: spaceBetweenMAA,
                  children: [
                    Text(
                      appLocalization.isSalesOnline,
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
                dividerWidget(),
                Row(
                  mainAxisAlignment: spaceBetweenMAA,
                  children: [
                    Text(
                      appLocalization.isPurchaseOnline,
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
                dividerWidget(),
                Row(
                  mainAxisAlignment: spaceBetweenMAA,
                  children: [
                    Text(
                      appLocalization.isZeroSalesAllowed,
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
                      initialValue: controller.isZeroSalesAllowed.value,
                    ),
                  ],
                ),
                dividerWidget(),
                Column(
                  children: [
                    _buildSettingButton(
                      text: appLocalization.printPaperType,
                      icon: TablerIcons.printer,
                      trailingIcon: TablerIcons.chevron_right,
                      isOpen:
                          controller.buttons.value == Buttons.printPaperType,
                      onTap: () {
                        controller.changeButton(Buttons.printPaperType);
                      },
                    ),
                    if (controller.buttons.value == Buttons.printPaperType)
                      Container(
                        color: Colors.white,
                        width: Get.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.printerTypeList.length,
                          itemBuilder: (context, index) {
                            final item = controller.printerTypeList[index];
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
                dividerWidget(),
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
                          controller
                              .setPrinterNewLine(int.tryParse(value) ?? 0);
                        },
                        onFieldSubmitted: (value) {
                          controller
                              .setPrinterNewLine(int.tryParse(value) ?? 0);
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
        );
      },
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
    required IconData icon,
    required String text,
    required IconData trailingIcon,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: colors.defaultFontColor,
            size: 24,
          ),
          8.width,
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
