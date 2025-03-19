import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/entity/onboard_entity.dart';

import '/app/core/core_model/logged_user.dart';
import '/app/core/core_model/setup.dart';

class SplashController extends BaseController {
  final onBoardSetupData = Rx<OnboardEntity?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    await navigatePage();
  }

  Future<void> navigatePage() async {
    await Future.delayed(const Duration(seconds: 1));

    String finalBaseUrl;

    final String baseUrl = await prefs.getBaseUrl();
    if (baseUrl.isEmpty) {
      await prefs.setBaseUrl('http://www.terminalbd.com/flutter-api/');
      finalBaseUrl = await prefs.getBaseUrl();
    } else {
      finalBaseUrl = baseUrl;
    }
    services.dio.baseUrl = finalBaseUrl;
    services.updateBaseUrl(finalBaseUrl);

    final bool isLicenseValid = await prefs.getIsLicenseValid();
    final bool isLogin = await prefs.getIsLogin();

    if (isLicenseValid && isLogin) {
      final setupData = await dbHelper.getAll(tbl: dbTables.tableSetup);
      SetUp.fromJson(setupData[0]);

      final loggedUserData = await dbHelper.getAllWhr(
        tbl: dbTables.tableUsers,
        where: 'user_name==? AND password==?',
        whereArgs: [
          await prefs.getLoggedUserName(),
          await prefs.getLoggedUserPassword(),
        ],
      );

      if (loggedUserData.isNotEmpty) {
        LoggedUser.fromJson(loggedUserData[0]);
        Get.offAllNamed(Routes.dashboard);
      } else {
        toast('Invalid Credentials');
      }
    }
    if (!isLicenseValid) {
      await dataFetcher(future: getOnboardSetup);
      if (onBoardSetupData.value?.onboard == 1) {
        Get.offAllNamed(
          Routes.onboarding,
          arguments: {'onboardData': onBoardSetupData.value},
        );
      } else {
        Get.offAllNamed(Routes.license);
      }
    }

    if (isLicenseValid && !isLogin) {
      final setupData = await dbHelper.getAll(tbl: dbTables.tableSetup);
      SetUp.fromJson(setupData[0]);
      Get.offAllNamed(Routes.login);
    }
  }

  Future<void> getOnboardSetup() async {
    final response = await services.getOnboardSetup();
    if (response != null) {
      onBoardSetupData.value = response;
    }
  }
}
