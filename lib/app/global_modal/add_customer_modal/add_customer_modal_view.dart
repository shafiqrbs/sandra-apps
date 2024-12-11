import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import 'add_customer_modal_controller.dart';

class AddCustomerModalView extends BaseView<AddCustomerModalController> {
  AddCustomerModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AddCustomerModalController>(
      init: AddCustomerModalController(),
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
                        textController: controller.userNameController.value,
                        preFixIcon: TablerIcons.user,
                        label: appLocalization.name,
                        hint: appLocalization.enterNameHere,
                        errorMsg: appLocalization.nameRequired,
                        isRequired: true,
                        textFieldHeight: textFieldHeight,
                      ),
                      0.height,
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
                      0.height,
                      FBString(
                        textController:
                            controller.openingBalanceController.value,
                        keyboardType: numberInputType,
                        preFixIcon: TablerIcons.cash,
                        label: appLocalization.openingBalance,
                        hint: appLocalization.enterOpeningBalance,
                        errorMsg: '',
                        isRequired: false,
                        textFieldHeight: textFieldHeight,
                      ),
                      0.height,
                      FBString(
                        textController: controller.emailController.value,
                        isRequired: false,
                        label: appLocalization.email,
                        hint: appLocalization.enterEmail,
                        errorMsg: '',
                        preFixIcon: TablerIcons.mail,
                        textFieldHeight: textFieldHeight,
                      ),
                      0.height,
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
