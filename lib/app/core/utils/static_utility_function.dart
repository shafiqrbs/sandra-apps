import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/core_model/setup.dart';
import '/app/core/db_helper/db_helper.dart';
import '/app/core/session_manager/session_manager.dart';
import '/app/core/widget/common_confirmation_modal.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

final prefs = SessionManager();
final dbHelper = DbHelper.instance;

Future<bool> insertSplashDataToDb({
  required Map<String, dynamic> splashData,
}) async {
  if (splashData.isNotEmpty) {
    if (splashData['setup'] != null && splashData['setup'].isNotEmpty) {
      SetUp.fromJson(splashData['setup'][0]);
    } else {
      await prefs.setIsLicenseValid(isLicenseValid: false);
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.pleaseTryAgain,
      );
      return false;
    }
    final keys = splashData.keys.toList();

    await Future.forEach<String>(
      keys,
      (key) async {
        final value = splashData[key];
        if (value != null && value is List && value.isNotEmpty) {
          final list = value.map((e) => Map<String, dynamic>.from(e)).toList();
          await dbHelper.insertList(
            deleteBeforeInsert: true,
            tableName: key,
            dataList: list,
          );
        }
      },
    );
  } else {
    await prefs.setIsLicenseValid(isLicenseValid: false);
    showSnackBar(
      type: SnackBarType.error,
      message: appLocalization.pleaseTryAgain,
    );
    return false;
  }

  await prefs.setIsLicenseValid(isLicenseValid: true);
  showSnackBar(
    type: SnackBarType.success,
    message: appLocalization.licenseAndKeyValidatedSuccessfully,
  );
  return true;
}

Future<void> makeCall(
  String number,
  BuildContext context,
) async {
  final shouldCall = await showDialog(
    context: context,
    builder: (context) {
      return CommonConfirmationModal(
        title: appLocalization.areYouSure,
      );
    },
  );

  if (shouldCall == true) {
    url_launcher.launch(
      'tel:+88$number',
    );
  }
}

Future<void> messageCustomer(
  String number,
  BuildContext context,
) async {
  final shouldMsg = await showDialog(
    context: context,
    builder: (context) {
      return CommonConfirmationModal(
        title: appLocalization.areYouSure,
      );
    },
  );

  if (shouldMsg == true) {
    url_launcher.launch(
      'sms:+88$number',
    );
  }
}

Future<bool> confirmationModal({
  required String msg,
}) async {
  final confirmation = await showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return CommonConfirmationModal(
            title: msg,
          );
        },
      ) ??
      false;

  return confirmation;
}
