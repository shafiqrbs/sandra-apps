import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_controller.dart';
import '/app/core/core_model/setup.dart';

class SyncModalController extends BaseController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> syncCustomer() async {
    await dataFetcher(
      future: () async {
        await 5.delay();
        //await services.syncCustomer();
      },
    );
  }

  Future<void> sync() async {
    final license = await prefs.getLicenseKey();
    final activeKey = await prefs.getActiveKey();
    await dataFetcher(
      future: () async {
        final value = await services.submitLicense(
          license: license,
          activeKey: activeKey,
        );
        if (value != null) {
          final isInserted = await insertSplashDataToDb(
            splashData: value,
          );

          if (isInserted) {
            toast(appLocalization.licenseAndKeyValidatedSuccessfully);
          }
        }
      },
    );
  }

  Future<bool> insertSplashDataToDb({
    required Map<String, dynamic> splashData,
  }) async {
    if (splashData.isNotEmpty) {
      if (splashData['setup'] != null && splashData['setup'].isNotEmpty) {
        SetUp.fromJson(splashData['setup'][0]);
      } else {
        await prefs.setIsLicenseValid(isLicenseValid: false);
        toast('please_try_again'.tr);
        return false;
      }
      final keys = splashData.keys.toList();

      //async loop
      await Future.forEach<String>(
        keys,
        (key) async {
          final value = splashData[key];
          if (value != null && value is List && value.isNotEmpty) {
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
      toast('please_try_again'.tr);
      return false;
    }

    await prefs.setIsLicenseValid(isLicenseValid: true);
    toast('license_and_key_validated_successfully'.tr);
    return true;
  }
}
