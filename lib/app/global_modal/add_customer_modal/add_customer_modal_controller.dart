import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';

import '/app/core/base/base_controller.dart';
import '/app/entity/customer.dart';

class AddCustomerModalController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController().obs;

  final mobileController = TextEditingController().obs;

  final openingBalanceController = TextEditingController().obs;

  final emailController = TextEditingController().obs;

  final addressController = TextEditingController().obs;

  final isUserNameFieldValid = true.obs;

  Customer? createdCustomer;

  Future<void> addCustomer() async {
    if (formKey.currentState!.validate()) {
      await dataFetcher(
        future: () async {
          final response = await services.addCustomer(
            name: userNameController.value.text,
            mobile: mobileController.value.text,
            address: addressController.value.text,
            email: emailController.value.text,
            openingBalance: openingBalanceController.value.text,
          );
          if (response != null) {
            await dbHelper.insertList(
              deleteBeforeInsert: false,
              tableName: dbTables.tableCustomers,
              dataList: [
                response.toJson(),
              ],
            );
            createdCustomer = response;
          }
        },
      );
      if (createdCustomer != null) {
        Get.back(
          result: createdCustomer,
        );
      } else {
        showSnackBar(
          message: appLocalization.error,
        );
      }
    }
  }

  void resetField() {
    userNameController.value.clear();
    mobileController.value.clear();
    openingBalanceController.value.clear();
    emailController.value.clear();
    addressController.value.clear();
    Get.back(result: true);
  }
}
