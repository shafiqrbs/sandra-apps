import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/fb_string.dart';
import 'package:sandra/app/global_modal/add_category_modal/add_category_modal_controller.dart';

class AddCategoryModalView extends BaseView<AddCategoryModalController> {
  @override
  Widget build(BuildContext context) {
    return GetX<AddCategoryModalController>(
      init: AddCategoryModalController(),
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
                      if (controller.preCategory != null)
                        RowButton(
                          buttonName: appLocalization.update,
                          leftIcon: TablerIcons.edit,
                          onTap: controller.updateCategory,
                          isOutline: false,
                        ),
                      if (controller.preCategory == null)
                        RowButton(
                          buttonName: appLocalization.save,
                          leftIcon: TablerIcons.device_floppy,
                          onTap: controller.addCategory,
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
