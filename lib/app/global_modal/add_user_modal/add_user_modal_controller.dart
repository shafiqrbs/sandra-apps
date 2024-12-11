import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/base/base_controller.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/user.dart';

class AddUserModalController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController().obs;
  final userNameController = TextEditingController().obs;
  final mobileController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final selectedRole = 'user'.obs;

  void resetField() {
    nameController.value.clear();
    userNameController.value.clear();
    mobileController.value.clear();
    emailController.value.clear();
    addressController.value.clear();
  }

  Future<void> addUser() async {
    if (formKey.currentState!.validate()) {
      User? createdUser;
      await dataFetcher(
        future: () async {
          final response = await services.addUser(
            name: nameController.value.text,
            userName: userNameController.value.text,
            mobile: mobileController.value.text,
            address: addressController.value.text,
            email: emailController.value.text,
            role: selectedRole.value,
          );
          if (response != null) {
            await dbHelper.insertList(
              deleteBeforeInsert: false,
              tableName: dbTables.tableUsers,
              dataList: [
                response.toJson(),
              ],
            );
            createdUser = response;
          }
        },
      );
      if (createdUser != null) {
        Get.back(
          result: createdUser,
        );
        showSnackBar(
          type: SnackBarType.success,
          message: appLocalization.save,
        );
      } else {
        showSnackBar(
          type: SnackBarType.error,
          message: appLocalization.failedToCreateCustomer,
        );
      }
    }
  }

  void changeRole(String s) {
    selectedRole.value = s;
  }
}
