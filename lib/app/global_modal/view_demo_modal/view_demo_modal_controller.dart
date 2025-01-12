import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/logged_user.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/entity/business_type.dart';
import 'package:sandra/app/pages/intro/onboarding/controllers/onboarding_controller.dart';
import 'package:sandra/app/routes/app_pages.dart';

import '/app/core/abstract_controller/printer_controller.dart';

class ViewDemoModalController extends PrinterController {
  final businessTypeList = Rx<List<BusinessType>?>(null);
  final tappedIndex = (-1).obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    final onboardingController = Get.find<OnboardingController>();
    businessTypeList.value = onboardingController.onBoardSetupData.value?.demo;
  }

  void setTappedIndex(int index) {
    if (tappedIndex.value == index) {
      tappedIndex.value = -1; // Collapse if the same item is clicked
    } else {
      tappedIndex.value = index; // Expand the clicked item
    }
    tappedIndex.refresh();
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
