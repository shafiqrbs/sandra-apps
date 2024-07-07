import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/core_model/setup.dart';
import 'package:nb_utils/nb_utils.dart';

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
          final value = await services.submitLicense(
            license: licenseNumber,
            activeKey: activeKey,
            shouldShowLoader: false,
          );
          if (value != null) {
            final isInserted = await insertSplashDataToDb(
              splashData: value,
            );

            if (isInserted) {
              Get.offAllNamed(Routes.login);
            }
          }
        },
      );
    }
  }

  Future<bool> insertSplashDataToDb({
    required Map<String, dynamic> splashData,
  }) async {
    if (splashData.isNotEmpty) {
      if (splashData['setup'] != null && splashData['setup'].isNotEmpty) {
        SetUp.fromJson(splashData['setup'][0]);
      } else {
        await prefs.setIsLicenseValid(isLicenseValid: false);
        toast('please_try_again'.tr);
        return false;
      }
      final keys = splashData.keys.toList();

      //async loop
      await Future.forEach<String>(
        keys,
        (key) async {
          final value = splashData[key];
          if (value != null && value is List && value.isNotEmpty) {
            await dbHelper.insertList(
              deleteBeforeInsert: true,
              tableName: key,
              dataList: value.map((e) => Map<String, dynamic>.from(e)).toList(),
            );
          }
        },
      );
    } else {
      await prefs.setIsLicenseValid(isLicenseValid: false);
      toast('please_try_again'.tr);
      return false;
    }

    await prefs.setIsLicenseValid(isLicenseValid: true);
    toast('license_and_key_validated_successfully'.tr);
    return true;
  }
}
