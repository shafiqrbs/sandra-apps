import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/entity/business_type.dart';
import 'package:sandra/app/entity/store_setup.dart';

import '/app/core/base/base_controller.dart';

class CreateStoreController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final businessTypeList = Rx<List<BusinessType>?>(null);
  final selectedBusinessType = Rx<BusinessType?>(null);
  final shopNameController = TextEditingController(text: '');
  final mobileController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final addressController = TextEditingController(text: '');

  final nameController = TextEditingController(text: '');
  final userNameController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  final isAllowReadyStock = false.obs;
  final isAllowTerms = false.obs;
  final isShowErrorMsg = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await dataFetcher(future: getBusinessTypeList);
  }

  Future<void> getBusinessTypeList() async {
    final response = await services.getBusinessTypeList();
    businessTypeList.value = response;
  }

  Future<void> buildStore() async {
    if (!formKey.currentState!.validate() ||
        selectedBusinessType.value == null) {
      isShowErrorMsg.value = true;
      return;
    }
    isShowErrorMsg.value = false;

    // API call to create shop
    final logs = StoreSetup(
      appSlug: selectedBusinessType.value?.appSlug,
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

    await dataFetcher(
      future: () async {
        final response = await services.setupStore(logs: logs);
        if (kDebugMode) {
          print('Response: $response');
        }
      },
    );
  }

  Future<void> onBusinessTypeChange(BusinessType? value) async {
    if (value == null) {
      isShowErrorMsg.value = true;
      return;
    }
    isShowErrorMsg.value = false;
    selectedBusinessType.value = value;
  }
}
