import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
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
                      controller: ValueNotifier(controller.isSalesOnline.value),
                      onChanged: (value) async {
                        controller.setSalesOnline(value);
                      },
                      borderRadius: BorderRadius.circular(4),
                      height: 20,
                      width: 40,
                      activeColor: Color(0xFFFAF3F0),
                      initialValue: controller.isSalesOnline.value,
                    ),
                    /*Switch(
                      value: controller.isSalesOnline.value,
                      onChanged: controller.setSalesOnline,
                      activeColor: Color(0xFFFAF3F0),
                      activeTrackColor: Color(0xFFE6C9BA),
                      thumbColor: MaterialStateProperty.resolveWith ((Set  states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.blue.withOpacity(.48);
                        }
                        return controller.isSalesOnline.value ? colors.primaryBaseColor : colors.secondaryBaseColor;
                      }),
                      inactiveTrackColor: Colors.white,
                    ),*/
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
                      controller: ValueNotifier(controller.isPurchaseOnline.value),
                      onChanged: (value) async {
                        controller.setPurchaseOnline(value);
                      },
                      borderRadius: BorderRadius.circular(4),
                      height: 20,
                      width: 40,
                      initialValue: controller.isPurchaseOnline.value,
                    ),
                    /*Switch(
                      value: controller.isPurchaseOnline.value,
                      onChanged: controller.setPurchaseOnline,
                    ),*/
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
                      controller: ValueNotifier(controller.isZeroSalesAllowed.value),
                      onChanged: (value) async {
                        controller.setZeroSalesAllowed(value);
                      },
                      borderRadius: BorderRadius.circular(4),
                      height: 20,
                      width: 40,
                      initialValue: controller.isZeroSalesAllowed.value,
                    ),
                    /*Switch(
                      value: controller.isZeroSalesAllowed.value,
                      onChanged: controller.setZeroSalesAllowed,
                    ),*/
                  ],
                ),
                dividerWidget(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: spaceBetweenMAA,
                      children: [
                        Text(
                          'Print Paper Type',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (controller.printerType.value.isEmpty)
                          const CircularProgressIndicator()
                        else
                          DropdownButton<String>(
                            value: controller.printerType.value,
                            items: controller.printerTypeList,
                            onChanged: (value) async {
                              if (value == null) return;
                              controller.setPrinterType(value);
                            },
                          ),
                      ],
                    ),
                    Container(
                      child: Column(
                        children: [

                        ],
                      ),
                    ),
                  ],
                ),
                dividerWidget(),
                Row(
                  mainAxisAlignment: spaceBetweenMAA,
                  children: [
                    Text(
                      'Print End New Line',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (controller.printerType.value.isEmpty)
                      const CircularProgressIndicator()
                    else
                      DropdownButton<int>(
                        value: controller.printerNewLine.value,
                        items: controller.newLineList,
                        onChanged: (value) async {
                          if (value == null) return;
                          controller.setPrinterNewLine(value);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dividerWidget(){
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
