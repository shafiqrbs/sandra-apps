import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/singleton_classes/color_schema.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/core/core_model/setup.dart';
import '/app/routes/app_pages.dart';

class SplashController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();
    await navigatePage();
    await getThemeColor();
  }

  Future<void> getThemeColor() async {
    final isDarkMode = await prefs.getIsEnableDarkMode();
    if (isDarkMode) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }

    ColorSchema.fromJson(
      Get.isDarkMode ? darkColor : lightColor,
    );
  }

  Future<void> navigatePage() async {
    await Future.delayed(const Duration(seconds: 1));

    final bool isLicenseValid = await prefs.getIsLicenseValid();
    final bool isLogin = await prefs.getIsLogin();

    if (isLicenseValid && isLogin) {
      final setupData = await dbHelper.getAll(tbl: dbTables.tableSetup);
      SetUp.fromJson(setupData[0]);

      final loggedUserData = await dbHelper.getAllWhr(
        tbl: dbTables.tableUsers,
        where: 'user_name==? AND password==?',
        whereArgs: [
          await prefs.getLoggedUserName(),
          await prefs.getLoggedUserPassword(),
        ],
      );

      if (loggedUserData.isNotEmpty) {
        LoggedUser.fromJson(loggedUserData[0]);
        Get.offAllNamed(Routes.dashboard);
      } else {
        toast('Invalid Credentials');
      }
    }
    if (!isLicenseValid) {
      Get.offAllNamed(Routes.license);
    }

    if (isLicenseValid && !isLogin) {
      final setupData = await dbHelper.getAll(tbl: dbTables.tableSetup);
      SetUp.fromJson(setupData[0]);
      Get.offAllNamed(Routes.login);
    }
  }
}
