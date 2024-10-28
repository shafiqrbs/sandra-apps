import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/base/base_view.dart';
import 'package:sandra/app/core/widget/fb_string.dart';
import 'package:sandra/app/core/widget/row_button.dart';

import 'add_user_modal_controller.dart';

class AddUserModalView extends BaseView<AddUserModalController> {
  AddUserModalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AddUserModalController>(
      init: AddUserModalController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.whiteColor,
            ),
            child: Column(
              children: [
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      8.height,
                      FBString(
                        textController: controller.nameController.value,
                        preFixIcon: TablerIcons.user,
                        label: appLocalization.userName,
                        hint: appLocalization.enterUsernameHere,
                        errorMsg: appLocalization.userNameRequired,
                        isRequired: true,
                        textFieldHeight: textFieldHeight,
                      ),
                      FBString(
                        textController: controller.userNameController.value,
                        preFixIcon: TablerIcons.user,
                        label: appLocalization.name,
                        hint: appLocalization.enterNameHere,
                        errorMsg: appLocalization.nameRequired,
                        isRequired: true,
                        textFieldHeight: textFieldHeight,
                      ),
                      FBString(
                        textController: controller.mobileController.value,
                        keyboardType: phoneInputType,
                        preFixIcon: TablerIcons.device_mobile,
                        label: appLocalization.mobile,
                        hint: appLocalization.enterMobileNumberHere,
                        errorMsg: appLocalization.mobileNoRequired,
                        isRequired: true,
                        textFieldHeight: textFieldHeight,
                      ),
                      FBString(
                        textController: controller.emailController.value,
                        isRequired: false,
                        label: appLocalization.email,
                        hint: appLocalization.enterEmail,
                        errorMsg: '',
                        preFixIcon: TablerIcons.mail,
                        textFieldHeight: textFieldHeight,
                      ),
                      _buildCustomRadioButton(
                        title: appLocalization.manager,
                        isSelected: controller.selectedRole.value == 'manager',
                        onTap: () {
                          controller.changeRole('manager');
                        },
                      ),
                      16.height,
                      _buildCustomRadioButton(
                        title: appLocalization.user,
                        isSelected: controller.selectedRole.value == 'user',
                        onTap: () {
                          controller.changeRole('user');
                        },
                      ),
                      16.height,
                      FBString(
                        textController: controller.addressController.value,
                        isRequired: false,
                        label: appLocalization.address,
                        hint: appLocalization.enterAddressHere,
                        errorMsg: '',
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
                    color: colors.primaryColor50,
                  ),
                  //height: 100,
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RowButton(
                        buttonName: appLocalization.reset,
                        leftIcon: TablerIcons.restore,
                        onTap: controller.resetField,
                        isOutline: true,
                      ),
                      16.width,
                      RowButton(
                        buttonName: appLocalization.save,
                        leftIcon: TablerIcons.device_floppy,
                        onTap: controller.addUser,
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

  Widget _buildCustomRadioButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? colors.primaryColor700
                    : colors.secondaryColor200,
              ),
            ),
            child: isSelected
                ? Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primaryColor700,
                    ),
                  )
                : Container(),
          ),
          16.width,
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }
}
