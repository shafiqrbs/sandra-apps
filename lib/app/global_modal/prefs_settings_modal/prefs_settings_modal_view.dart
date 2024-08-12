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
                      onChanged: (value) async {
                        controller.isSalesOnline.value = value;
                        await controller.prefs.setIsSalesOnline(
                          isSalesOnline: value,
                        );
                      },
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
                      onChanged: (value) async {
                        controller.isPurchaseOnline.value = value;
                        await controller.prefs.setIsPurchaseOnline(
                          isPurchaseOnline: value,
                        );
                      },
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
                      onChanged: (value) async {
                        controller.isZeroSalesAllowed.value = value;
                        await controller.prefs.setIsZeroSalesAllowed(
                          isZeroAllowed: value,
                        );
                      },
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
                        items: <String>['80 mm', '58 mm']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) async {
                          controller.printerType.value = value!;
                          await controller.prefs.setPrintPaperType(
                            value,
                          );
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
