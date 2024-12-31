import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/logged_user.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/entity/business_type.dart';
import 'package:sandra/app/pages/intro/create_store/controllers/create_store_controller.dart';
import 'package:sandra/app/routes/app_pages.dart';

import '/app/core/abstract_controller/printer_controller.dart';

class ViewDemoModalController extends PrinterController {
  final businessTypeList = Rx<List<BusinessType>?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();

    final createStoreController = Get.find<CreateStoreController>();
    businessTypeList.value =
        businessTypeList.value ?? createStoreController.businessTypeList.value;
  }

  Future<void> navigateToDemo(BusinessType type) async {
    // Navigate to the demo page
    await submitLicense(
      type: type,
    );
  }

  Future<void> submitLicense({
    required BusinessType type,
  }) async {
    print('licenseNo: ${type.licenseNo}');
    print('activeKey: ${type.activeKey}');
    print('userName: ${type.userName}');
    print('password: ${type.password}');
    if (type.licenseNo == null ||
        type.activeKey == null ||
        type.userName == null ||
        type.password == null) {
      toast('Something went wrong');
      return;
    }
    await dataFetcher(
      future: () async {
        final value = await services.submitLicense(
          license: type.licenseNo!,
          activeKey: type.activeKey!,
        );
        if (value != null) {
          final isInserted = await insertSplashDataToDb(
            splashData: value,
          );

          if (isInserted) {
            await prefs.setLicenseKey(licenseKey: type.licenseNo!);
            await prefs.setActiveKey(activeKey: type.activeKey!);
            await submitLogin(
              userName: type.userName!,
              password: type.password!,
            );
          }
        }
      },
    );
  }

  Future<void> submitLogin({
    required String userName,
    required String password,
  }) async {
    try {
      final loggedUserdata = await dbHelper.getAllWhr(
        tbl: dbTables.tableUsers,
        where: 'user_name==? AND password==?',
        whereArgs: [
          userName,
          password,
        ],
      );

      if (loggedUserdata.isNotEmpty) {
        await prefs.setIsLogin(isLogin: true);
        await prefs.setLoggedUserName(userName);
        await prefs.setLoggedUserPassword(password);
        LoggedUser.fromJson(loggedUserdata[0]);
        Get.offAllNamed(Routes.dashboard);
      } else {
        toast('Invalid Credentials');
      }
    } finally {}
  }
}
