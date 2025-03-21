import 'package:sandra/app/core/importer.dart';

import '/app/core/core_model/setup.dart';

class LicenseController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final licenseNumberController = TextEditingController(
    text: kDebugMode ? (true ? '01820584047' : '01852892044') : '',
  );
  final activeKeyController = TextEditingController(
    text: kDebugMode ? (true ? '1671288227' : '1551378444') : '',
  );

  Future<void> submitLicense() async {
    services.updateBaseUrl(
      'http://www.terminalbd.com/flutter-api/',
    );
    await prefs.setBaseUrl(
      'http://www.terminalbd.com/flutter-api/',
    );

    if (formKey.currentState!.validate()) {
      final licenseNumber = licenseNumberController.text;
      final activeKey = activeKeyController.text;

      await dataFetcher(
        future: () async {
          final value = await services.submitLicense(
            license: licenseNumber,
            activeKey: activeKey,
          );
          if (value != null) {
            final isInserted = await insertSplashDataToDb(
              splashData: value,
            );

            if (isInserted) {
              await prefs.setLicenseKey(licenseKey: licenseNumber);
              await prefs.setActiveKey(activeKey: activeKey);
              Get.offAllNamed(Routes.login);
            }
          }
        },
      );
    }
  }

  Future<bool> insertSplashDataToDb({
    required Map<String, dynamic> splashData,
  }) async {
    if (splashData.isNotEmpty) {
      if (splashData['setup'] != null && splashData['setup'].isNotEmpty) {
        SetUp.fromJson(splashData['setup'][0]);
      } else {
        await prefs.setIsLicenseValid(isLicenseValid: false);
        toast(appLocalization.pleaseTryAgain);
        return false;
      }
      final keys = splashData.keys.toList();

      //async loop
      await Future.forEach<String>(
        keys,
        (key) async {
          final value = splashData[key];
          if (value != null && value is List) {
            if (value.isEmpty) {
              await dbHelper.deleteAll(tbl: key);
              return;
            }
            await dbHelper.insertList(
              deleteBeforeInsert: true,
              tableName: key,
              dataList: value.map((e) => Map<String, dynamic>.from(e)).toList(),
            );
          }
        },
      );
    } else {
      await prefs.setIsLicenseValid(isLicenseValid: false);
      toast(appLocalization.pleaseTryAgain);
      return false;
    }

    await prefs.setIsLicenseValid(isLicenseValid: true);
    toast(appLocalization.licenseAndKeyValidatedSuccessfully);
    return true;
  }
}
