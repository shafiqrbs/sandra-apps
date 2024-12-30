import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';

class CreateStoreController extends BaseController {
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
}
