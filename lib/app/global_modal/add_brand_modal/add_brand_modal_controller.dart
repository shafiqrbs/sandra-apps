import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/brand.dart';

class AddBrandModalController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;

  Brand? preBrand;
  Brand? createBrand;

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
      _onApiCall();
    }
  }

  // update
  Future<void> updateMasterData() async {
    if (formKey.currentState!.validate()) {
      final confirmation = await confirmationModal(
        msg: appLocalization.areYouSure,
      );
      if (!confirmation) return;
      await dataFetcher(
        future: () async {
          createBrand = await services.updateBrand(
            id: preBrand!.brandId!.toString(),
            name: nameController.value.text,
          );
          if (createBrand != null) {
            await dbHelper.updateWhere(
              tbl: dbTables.tableBrands,
              where: 'brand_id = ?',
              data: createBrand!.toJson(),
              whereArgs: [createBrand!.brandId],
            );
          }
        },
      );
      _onApiCall();
    }
  }

  void _onApiCall() {
    if (createBrand != null) {
      Get.back(
        result: createBrand,
      );
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.save,
      );
    }
  }
}
