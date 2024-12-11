import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/base/base_controller.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/brand.dart';

class AddBrandModalController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;

  void resetField() {
    nameController.value.clear();
  }

  Future<void> addMasterData() async {
    Brand? createBrand;
    if (formKey.currentState!.validate()) {
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
}
