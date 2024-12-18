import 'package:sandra/app/core/importer.dart';

import '/app/core/widget/show_snackbar.dart';
import '/app/entity/customer.dart';

class AddCustomerModalController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController().obs;

  final mobileController = TextEditingController().obs;

  final openingBalanceController = TextEditingController().obs;

  final emailController = TextEditingController().obs;

  final addressController = TextEditingController().obs;

  final isUserNameFieldValid = true.obs;
  Customer? preCustomer;

  Customer? createdCustomer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      preCustomer = args['customer'];
      userNameController.value.text = preCustomer!.name!;
      mobileController.value.text = preCustomer!.mobile!;
      emailController.value.text = preCustomer!.email!;
      addressController.value.text = preCustomer!.address!;
    }
  }

  Future<void> addCustomer() async {
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
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
    }
    _onApiCall();
  }

  void resetField() {
    userNameController.value.clear();
    mobileController.value.clear();
    openingBalanceController.value.clear();
    emailController.value.clear();
    addressController.value.clear();
    // Get.back(result: true);
  }

  Future<void> updateCustomer() async {
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
      await dataFetcher(
        future: () async {
          final response = await services.updateCustomer(
            customerId: preCustomer!.customerId.toString(),
            name: userNameController.value.text,
            address: addressController.value.text,
            email: emailController.value.text,
          );
          if (response != null) {
            await dbHelper.updateWhere(
              tbl: dbTables.tableCustomers,
              data: response.toJson(),
              where: 'customer_id = ?',
              whereArgs: [response.customerId],
            );
            createdCustomer = response;
          }
        },
      );
    }
    _onApiCall();
  }

  void _onApiCall() {
    if (createdCustomer != null) {
      Get.back(
        result: createdCustomer,
      );
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.save,
      );
    }
  }
}
