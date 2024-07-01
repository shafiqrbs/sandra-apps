import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/routes/app_pages.dart';

class LicenseController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final licenseNumberController = TextEditingController(text: '01737701702');
  final activeKeyController = TextEditingController(text: '1593579882');

  Future<void> submitLicense() async {
    if (formKey.currentState!.validate()) {
      final licenseNumber = licenseNumberController.text;
      final activeKey = activeKeyController.text;

      await dataFetcher(
        future: () async {
          await 10.delay();
          /* final value = await services.submitLicense(
            license: licenseNumber,
            activeKey: activeKey,
            shouldShowLoader: false,
          );
          if (value != null) {
            final isInserted = await UtilityFunctions().insertSplashDataToDb(
              splashData: value,
            );

            if (isInserted) {
              Get.offAllNamed(Routes.login);
            }
          }*/
        },
      );
    }
  }
}
