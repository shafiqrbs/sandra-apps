import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import 'add_vendor_modal_controller.dart';

class AddVendorModalView extends BaseView<AddVendorModalController> {
  AddVendorModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AddVendorModalController>(
      init: AddVendorModalController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.backgroundColor,
            ),
            child: Column(
              children: [
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      8.height,
                      FBString(
                        textController: controller.userNameController.value,
                        preFixIcon: TablerIcons.user,
                        label: 'user_name'.tr,
                        hint: 'enter_username_here'.tr,
                        errorMsg: 'user_name_required'.tr,
                        isRequired: true,
                        textFieldHeight: textFieldHeight,
                      ),
                      0.height,
                      FBString(
                        textController: controller.mobileController.value,
                        keyboardType: phoneInputType,
                        preFixIcon: TablerIcons.device_mobile,
                        label: 'mobile'.tr,
                        hint: 'enter_mobile_number_here'.tr,
                        errorMsg: 'mobile_no_required'.tr,
                        isRequired: true,
                        textFieldHeight: textFieldHeight,
                      ),
                      0.height,
                      FBString(
                        textController:
                            controller.openingBalanceController.value,
                        keyboardType: numberInputType,
                        preFixIcon: TablerIcons.cash,
                        label: 'opening_balance'.tr,
                        hint: 'enter_your_balance'.tr,
                        errorMsg: ''.tr,
                        isRequired: false,
                        textFieldHeight: textFieldHeight,
                      ),
                      0.height,
                      FBString(
                        textController: controller.emailController.value,
                        isRequired: false,
                        label: 'Email'.tr,
                        hint: 'enter_email'.tr,
                        errorMsg: ''.tr,
                        preFixIcon: TablerIcons.mail,
                        textFieldHeight: textFieldHeight,
                      ),
                      0.height,
                      FBString(
                        textController: controller.addressController.value,
                        isRequired: false,
                        label: 'address'.tr,
                        hint: 'enter_address_here'.tr,
                        errorMsg: ''.tr,
                        lines: 4,
                        textInputAction: TextInputAction.done,

                        //textFieldHeight: textFieldHeight,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.moduleFooterColor,
                  ),
                  //height: 100,
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RowButton(
                        buttonName: 'reset'.tr,
                        leftIcon: TablerIcons.restore,
                        onTap: controller.resetField,
                        isOutline: true,
                      ),
                      16.width,
                      RowButton(
                        buttonName: 'save'.tr,
                        leftIcon: TablerIcons.device_floppy,
                        onTap: controller.addCustomer,
                        isOutline: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
}
