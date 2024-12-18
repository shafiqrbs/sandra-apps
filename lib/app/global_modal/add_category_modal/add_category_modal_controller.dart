import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/category.dart';

class AddCategoryModalController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;
  Category? preCategory;
  Category? createdCategory;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      preCategory = args['category'] as Category?;
      if (preCategory != null) {
        nameController.value.text = preCategory!.name ?? '';
      }
    }
  }

  void resetField() {
    nameController.value.clear();
  }

  Future<void> addCategory() async {
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
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
      _onApiCall();
    }
  }

  Future<void> updateCategory() async {
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
      await dataFetcher(
        future: () async {
          createdCategory = await services.updateCategory(
            id: preCategory!.categoryId!.toString(),
            name: nameController.value.text,
          );
          if (createdCategory != null) {
            await dbHelper.updateWhere(
              tbl: dbTables.tableCategories,
              data: createdCategory!.toJson(),
              where: 'category_id = ?',
              whereArgs: [createdCategory!.categoryId],
            );
          }
        },
      );
      _onApiCall();
    }
  }

  void _onApiCall() {
    if (createdCategory != null) {
      Get.back(
        result: createdCategory,
      );
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.save,
      );
    }
  }
}
