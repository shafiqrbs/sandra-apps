import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/brand.dart';

class AddBrandModalController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;

  Brand? preBrand;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      preBrand = args['brand'];
      nameController.value.text = preBrand!.name!;
    }
  }

  void resetField() {
    nameController.value.clear();
  }

  Future<void> addMasterData() async {
    Brand? createBrand;
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
      await dataFetcher(
        future: () async {
          createBrand = await services.addBrand(
            name: nameController.value.text,
          );
          if (createBrand != null) {
            await dbHelper.insertList(
              deleteBeforeInsert: false,
              tableName: dbTables.tableBrands,
              dataList: [
                createBrand!.toJson(),
              ],
            );
          }
        },
      );
      if (createBrand != null) {
        Get.back(
          result: createBrand,
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

  // update
  Future<void> updateMasterData() async {
    Brand? updateBrand;
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
      await dataFetcher(
        future: () async {
          updateBrand = await services.updateBrand(
            id: preBrand!.brandId!.toString(),
            name: nameController.value.text,
          );
          if (updateBrand != null) {
            await dbHelper.updateWhere(
              tbl: dbTables.tableBrands,
              where: 'brand_id = ?',
              data: updateBrand!.toJson(),
              whereArgs: [updateBrand!.brandId],
            );
          }
        },
      );
      if (updateBrand != null) {
        Get.back(
          result: updateBrand,
        );
        showSnackBar(
          type: SnackBarType.success,
          message: appLocalization.update,
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
