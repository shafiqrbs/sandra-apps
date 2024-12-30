import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/entity/store_setup.dart';

import '/app/core/base/base_controller.dart';

class CreateStoreController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final selectedBusinessType = '';
  final shopNameController = TextEditingController(text: '');
  final mobileController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final addressController = TextEditingController(text: '');

  final nameController = TextEditingController(text: '');
  final userNameController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  final isAllowReadyStock = false.obs;
  final isAllowTerms = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> buildStore() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // API call to create shop
    final logs = StoreSetup(
      appSlug: 'medicine',
      storeName: shopNameController.text,
      mobile: mobileController.text,
      email: emailController.text,
      address: addressController.text,
      name: nameController.text,
      userName: userNameController.text,
      password: passwordController.text,
      isStock: isAllowReadyStock.value ? 1 : 0,
      termsCondition: isAllowTerms.value ? 1 : 0,
    );
    final response = await services.setupStore(logs: logs);
    print('Response: $response');
  }
}
