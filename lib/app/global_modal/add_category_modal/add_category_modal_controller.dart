import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/base/base_controller.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/category.dart';

class AddCategoryModalController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;

  void resetField() {
    nameController.value.clear();
  }

  Future<void> addCategory() async {
    if (formKey.currentState!.validate()) {
      Category? createdCategory;
      await dataFetcher(
        future: () async {
          createdCategory = await services.addCategory(
            name: nameController.value.text,
          );
          if (createdCategory != null) {
            await dbHelper.insertList(
              deleteBeforeInsert: false,
              tableName: dbTables.tableCategories,
              dataList: [
                createdCategory!.toJson(),
              ],
            );
          }
        },
      );
      if (createdCategory != null) {
        Get.back(
          result: createdCategory,
        );
        showSnackBar(
          type: SnackBarType.success,
          message: appLocalization.save,
        );
      } else {
        showSnackBar(
          type: SnackBarType.error,
          message: appLocalization.failed,
        );
      }
    }
  }
}
