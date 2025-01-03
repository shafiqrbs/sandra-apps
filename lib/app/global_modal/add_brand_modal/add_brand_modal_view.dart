import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/fb_string.dart';
import 'package:sandra/app/core/widget/row_button.dart';

import 'add_brand_modal_controller.dart';

class AddBrandModalView extends BaseView<AddBrandModalController> {
  AddBrandModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AddBrandModalController>(
      init: AddBrandModalController(),
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
                        label: appLocalization.name,
                        hint: appLocalization.enterNameHere,
                        errorMsg: appLocalization.nameRequired,
                        isRequired: true,
                        textFieldHeight: textFieldHeight,
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
                      if (controller.preBrand == null)
                        RowButton(
                          buttonName: appLocalization.save,
                          leftIcon: TablerIcons.device_floppy,
                          onTap: controller.addMasterData,
                          isOutline: false,
                        ),
                      if (controller.preBrand != null)
                        RowButton(
                          buttonName: appLocalization.update,
                          leftIcon: TablerIcons.device_floppy,
                          onTap: controller.updateMasterData,
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
