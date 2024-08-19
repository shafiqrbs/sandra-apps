import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Switch(
                      value: controller.isSalesOnline.value,
                      onChanged: controller.setSalesOnline,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: spaceBetweenMAA,
                  children: [
                    Text(
                      appLocalization.isPurchaseOnline,
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Switch(
                      value: controller.isPurchaseOnline.value,
                      onChanged: controller.setPurchaseOnline,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: spaceBetweenMAA,
                  children: [
                    Text(
                      appLocalization.isZeroSalesAllowed,
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Switch(
                      value: controller.isZeroSalesAllowed.value,
                      onChanged: controller.setZeroSalesAllowed,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: spaceBetweenMAA,
                  children: [
                    Text(
                      'Print Paper Type',
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
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
                Row(
                  mainAxisAlignment: spaceBetweenMAA,
                  children: [
                    Text(
                      'Print End New Line',
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
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
