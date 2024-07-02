import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/core_model/setup.dart';
import 'package:getx_template/app/core/db_helper/db_helper.dart';
import 'package:getx_template/app/core/session_manager/session_manager.dart';
import 'package:getx_template/app/core/widget/common_confirmation_modal.dart';
import 'package:nb_utils/nb_utils.dart';

class UtilityFunctions {
  final prefs = SessionManager();
  final dbHelper = DbHelper.instance;

  static UtilityFunctions? _instance;

  factory UtilityFunctions() => _instance ??= UtilityFunctions._internal();

  UtilityFunctions._internal();

  factory UtilityFunctions.instance() =>
      _instance ??= UtilityFunctions._internal();

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

      await Future.forEach<String>(
        keys,
        (key) async {
          final value = splashData[key];
          if (value != null && value is List && value.isNotEmpty) {
            await dbHelper.insertList(
              deleteBeforeInsert: true,
              tableName: key,
              dataList: value
                  .map(
                    (e) => Map<String, dynamic>.from(e),
                  )
                  .toList(),
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

  Future<void> makeCall(String number, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CommonConfirmationModal(
          title: 'do_you_want_to_make_a_call?'.tr,
        );
      },
    ).then(
      (value) {
        if (value == true) {
          UrlLauncher.launch(
            'tel:+88$number',
          );
        }
      },
    );
  }

  Future<void> messageCustomer(String number, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CommonConfirmationModal(
          title: 'do_you_want_to_send_a_message?'.tr,
        );
      },
    ).then(
      (value) {
        if (value == true) {
          UrlLauncher.launch(
            'sms:+88$number',
          );
        }
      },
    );
  }
}
