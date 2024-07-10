import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/entity/user.dart';
import 'package:getx_template/app/routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

class CreateExpenseController extends BaseController {
  final userManager = UserManager();
  final amountController = TextEditingController();
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void goToListPage() {
    Get.offNamed(
      Routes.expenseList,
    );
  }
}
