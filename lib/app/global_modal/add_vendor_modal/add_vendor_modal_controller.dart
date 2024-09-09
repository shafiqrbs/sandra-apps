import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/widget/show_snackbar.dart';
import '/app/entity/vendor.dart';

import '/app/core/base/base_controller.dart';

class AddVendorModalController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController().obs;

  final mobileController = TextEditingController().obs;

  final openingBalanceController = TextEditingController().obs;

  final emailController = TextEditingController().obs;

  final addressController = TextEditingController().obs;

  final isUserNameFieldValid = true.obs;

  Vendor? createdVendor;

  Future<void> addVendor() async {
    if (formKey.currentState!.validate()) {
      await dataFetcher(
        future: () async {
          createdVendor = await services.addVendor(
            name: userNameController.value.text,
            mobile: mobileController.value.text,
            address: addressController.value.text,
            email: emailController.value.text,
            openingBalance: openingBalanceController.value.text,
          );
          if (createdVendor != null) {
            await dbHelper.insertList(
              deleteBeforeInsert: false,
              tableName: dbTables.tableVendors,
              dataList: [
                createdVendor!.toJson(),
              ],
            );
          }
        },
      );

      if (createdVendor != null) {
        Get.back(
          result: createdVendor,
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
