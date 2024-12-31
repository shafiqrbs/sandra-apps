import 'package:sandra/app/core/importer.dart';

import '/app/core/widget/show_snack_bar.dart';
import '/app/entity/vendor.dart';

class AddVendorModalController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController().obs;

  final mobileController = TextEditingController().obs;

  final openingBalanceController = TextEditingController().obs;

  final emailController = TextEditingController().obs;

  final addressController = TextEditingController().obs;

  final isUserNameFieldValid = true.obs;

  Vendor? preVendor;

  Vendor? createdVendor;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      preVendor = args['vendor'];
      userNameController.value.text = preVendor!.name ?? '';
      emailController.value.text = preVendor!.email ?? '';
      addressController.value.text = preVendor!.address ?? '';
    }
  }

  Future<void> addVendor() async {
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
      await dataFetcher(
        future: () async {
          final response = await services.addVendor(
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

      _onApiCall();
    }
  }

  void resetField() {
    userNameController.value.clear();
    mobileController.value.clear();
    openingBalanceController.value.clear();
    emailController.value.clear();
    addressController.value.clear();
    // Get.back(result: true);
  }

  Future<void> updateVendor() async {
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
      await dataFetcher(
        future: () async {
          final response = await services.updateVendor(
            vendorId: preVendor!.vendorId.toString(),
            name: userNameController.value.text,
            address: addressController.value.text,
            email: emailController.value.text,
          );
          if (response != null) {
            await dbHelper.updateWhere(
              tbl: dbTables.tableVendors,
              data: response.toJson(),
              where: 'vendor_id = ?',
              whereArgs: [response.vendorId],
            );
            createdVendor = response;
          }
        },
      );

      _onApiCall();
    }
  }

  void _onApiCall() {
    if (createdVendor != null) {
      Get.back(
        result: createdVendor,
      );
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.save,
      );
    }
  }
}
