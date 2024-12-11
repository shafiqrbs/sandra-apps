import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/show_snackbar.dart';
import '/app/entity/vendor.dart';

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
          final response  = await services.addVendor(
            name: userNameController.value.text,
            mobile: mobileController.value.text,
            address: addressController.value.text,
            email: emailController.value.text,
            openingBalance: openingBalanceController.value.text,
          );
          if (response != null) {
            await dbHelper.insertList(
              deleteBeforeInsert: false,
              tableName: dbTables.tableVendors,
              dataList: [
                response.toJson(),
              ],
            );
            createdVendor = response;
          }
        },
      );

      if (createdVendor != null) {
        Get.back(
          result: createdVendor,
        );
        showSnackBar(
          type: SnackBarType.success,
          message: appLocalization.save,
        );
      } else {
        showSnackBar(
          type: SnackBarType.error,
          message: appLocalization.failedToCreateVendor,
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
