import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'prefs_keys.dart';

/// SessionManager class is used to manage the user session.
/// It uses SharedPreferences to store and retrieve session data.
class SessionManager {
  late SharedPreferences prefs;

  /// Singleton instance of SessionManager.
  static SessionManager? _instance;

  factory SessionManager() => _instance ??= SessionManager._internal();

  SessionManager._internal();

  /// Factory method to get the instance of SessionManager.
  factory SessionManager.getInstance() {
    return SessionManager();
  }

  /// Initialize the SharedPreferences instance.
  Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
    } on Exception catch (e) {
      // Handle initialization error, log the error, or throw it further.
      if (kDebugMode) {
        print('Error initializing SharedPreferences: $e');
      }
    }
  }

  /// set the language of the app.
  Future<void> setLanguage(
    String lang,
  ) async {
    await prefs.setString(
      prefsLanguage,
      lang,
    );
  }

  /// get the language of the app.
  Future<String> getLanguage() async {
    return prefs.getString(prefsLanguage) ?? 'en';
  }

  /// Set the login status of the user.
  Future<void> setIsLogin({
    required bool isLogin,
  }) async {
    await prefs.setBool(
      prefsIsLogin,
      isLogin,
    );
  }

  /// Get the login status of the user.
  Future<bool> getIsLogin() async {
    return prefs.getBool(prefsIsLogin) ?? false;
  }

  /// Set the username of the logged-in user.
  Future<void> setLoggedUserName(
    String userName,
  ) async {
    await prefs.setString(
      prefsLoggedUserName,
      userName,
    );
  }

  /// Get the username of the logged-in user.
  Future<String?> getLoggedUserName() async {
    return prefs.getString(prefsLoggedUserName);
  }

  /// Set the password of the logged-in user.
  Future<void> setLoggedUserPassword(
    String password,
  ) async {
    await prefs.setString(
      prefsLoggedUserPassword,
      password,
    );
  }

  /// Get the password of the logged-in user.
  Future<String?> getLoggedUserPassword() async {
    return prefs.getString(prefsLoggedUserPassword);
  }

  /// Set the license validity status.
  Future<void> setIsLicenseValid({
    required bool isLicenseValid,
  }) async {
    await prefs.setBool(
      prefsIsLicenseValid,
      isLicenseValid,
    );
  }

  /// set license key
  Future<void> setLicenseKey({
    required String licenseKey,
  }) async {
    await prefs.setString(
      prefsLicenseKey,
      licenseKey,
    );
  }

  /// get license key
  Future<String> getLicenseKey() async {
    return prefs.getString(prefsLicenseKey) ?? '';
  }

  /// set active key
  Future<void> setActiveKey({
    required String activeKey,
  }) async {
    await prefs.setString(
      prefsActiveKey,
      activeKey,
    );
  }

  /// get active key
  Future<String> getActiveKey() async {
    return prefs.getString(prefsActiveKey) ?? '';
  }

  /// Get the license validity status.
  Future<bool> getIsLicenseValid() async {
    return prefs.getBool(prefsIsLicenseValid) ?? false;
  }

  /// Set the print paper type.
  Future<void> setPrintPaperType(
    String printPaperType,
  ) async {
    await prefs.setString(
      prefsPrinterPaperType,
      printPaperType,
    );
  }

  /// Get the print paper type.
  Future<String> getPrintPaperType() async {
    return prefs.getString(prefsPrinterPaperType) ?? '80 mm';
  }

  /// Set is sales online
  Future<void> setIsSalesOnline({
    required bool isSalesOnline,
  }) async {
    await prefs.setBool(
      prefsIsSalesOnline,
      isSalesOnline,
    );
  }

  /// Get is sales online
  Future<bool> getIsSalesOnline() async {
    return prefs.getBool(prefsIsSalesOnline) ?? false;
  }

  /// Set is purchase online
  Future<void> setIsPurchaseOnline({
    required bool isPurchaseOnline,
  }) async {
    await prefs.setBool(
      prefsIsPurchaseOnline,
      isPurchaseOnline,
    );
  }

  /// Get is purchase online
  Future<bool> getIsPurchaseOnline() async {
    return prefs.getBool(prefsIsPurchaseOnline) ?? false;
  }

  /// set is zero allowed
  Future<void> setIsZeroSalesAllowed({
    required bool isZeroAllowed,
  }) async {
    await prefs.setBool(
      prefsIsZeroAllowed,
      isZeroAllowed,
    );
  }

  /// Get is printer allowed
  Future<bool> getIsPrinterAllowed() async {
    return prefs.getBool(prefsIsPrinterAllowed) ?? false;
  }

  /// set is printer allowed
  Future<void> setIsPrinterAllowed({
    required bool isPrinterAllowed,
  }) async {
    await prefs.setBool(
      prefsIsPrinterAllowed,
      isPrinterAllowed,
    );
  }

  /// get is zero allowed
  Future<bool> getIsZeroSalesAllowed() async {
    return prefs.getBool(prefsIsZeroAllowed) ?? true;
  }

  /// set is zero allowed
  Future<void> setPurchaseConfig(
    String config,
  ) async {
    await prefs.setString(
      prefsPurchaseConfig,
      config,
    );
  }

  /// get is zero allowed
  Future<String> getPurchaseConfig() async {
    return prefs.getString(prefsPurchaseConfig) ?? 'purchase_price';
  }

  /// set number of printer new line
  Future<void> setNumberOfPrinterNewLine(
    int newLine,
  ) async {
    await prefs.setInt(
      prefsNumberOfPrinterNewLine,
      newLine,
    );
  }

  /// get number of printer new line
  Future<int> getNumberOfPrinterNewLine() async {
    return prefs.getInt(prefsNumberOfPrinterNewLine) ?? 0;
  }

  ///set has printer
  Future<void> setHasPrinter({
    required bool hasPrinter,
  }) async {
    await prefs.setBool(
      prefsHasPrinter,
      hasPrinter,
    );
  }

  ///get has printer
  Future<bool> getHasPrinter() async {
    return prefs.getBool(prefsHasPrinter) ?? false;
  }

  /// is sales auto approve
  Future<void> setIsSalesAutoApprove({
    required bool isSalesAutoApprove,
  }) async {
    await prefs.setBool(
      prefsIsSalesAutoApprove,
      isSalesAutoApprove,
    );
  }

  /// get is sales auto approve
  Future<bool> getIsSalesAutoApprove() async {
    return prefs.getBool(prefsIsSalesAutoApprove) ?? false;
  }

  /// is purchase auto approve
  Future<void> setIsPurchaseAutoApprove({
    required bool isPurchaseAutoApprove,
  }) async {
    await prefs.setBool(
      prefsIsPurchaseAutoApprove,
      isPurchaseAutoApprove,
    );
  }

  /// get is purchase auto approve
  Future<bool> getIsPurchaseAutoApprove() async {
    return prefs.getBool(prefsIsPurchaseAutoApprove) ?? false;
  }
}
