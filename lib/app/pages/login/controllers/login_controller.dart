import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/routes/app_pages.dart';

class LoginController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController(
    text: 'alshefa4_shafiq',
  );
  final passwordController = TextEditingController(
    text: 'android',
  );
  final otpController = TextEditingController();
  final isUserNameFieldValid = true.obs;
  final isPasswordFieldValid = true.obs;
  final isSignUp = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> submitLogin() async {
    try {
      if (!formKey.currentState!.validate()) {
        toast('Check All Field');
        return;
      }

      await dbHelper.getAllWhr(
        tbl: dbTables.tableUsers,
        where: 'user_name==? AND password==?',
        whereArgs: [
          userNameController.value.text,
          passwordController.value.text,
        ],
      ).then(
        (value) async {
          if (value.isNotEmpty) {
            await prefs.setIsLogin(isLogin: true);
            await prefs.setLoggedUserName(userNameController.value.text);
            await prefs.setLoggedUserPassword(passwordController.value.text);
            LoggedUser.fromJson(value[0]);
            Get.offAllNamed(Routes.dashboard);
          } else {
            toast('Invalid Credentials');
          }
        },
      );
    } finally {}
  }
}
