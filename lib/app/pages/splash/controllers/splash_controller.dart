import '/app/core/base/base_controller.dart';

class SplashController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> navigatePage() async {
    await Future.delayed(const Duration(seconds: 1));

    final bool isLicenseValid = await prefs.getIsLicenseValid();
    final bool isLogin = await prefs.getIsLogin();
  }
}
