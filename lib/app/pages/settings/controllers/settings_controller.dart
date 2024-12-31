import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/abstract_controller/printer_controller.dart';
import 'package:sandra/app/core/db_helper/db_tables.dart';
import 'package:sandra/app/core/singleton_classes/color_schema.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/core/widget/show_snack_bar.dart';
import 'package:sandra/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import 'package:sandra/app/routes/app_pages.dart';

enum Buttons {
  purchase,
}

class SettingsController extends PrinterController {
  final buttons = Rx<Buttons?>(null);
  final isPrinterAllowed = ValueNotifier(false);
  final isEnableDarkMode = ValueNotifier(false);
  final isShowThemeColor = false.obs;
  final themeList = <String>[].obs;
  final selectedThemeColor = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isPrinterAllowed.value = await prefs.getIsPrinterAllowed();
    isEnableDarkMode.value = await prefs.getIsEnableDarkMode();
    selectedThemeColor.value = await prefs.getSelectedThemeName() ?? '';
    await fetchThemeList();
  }

  Future<void> fetchThemeList() async {
    final themeCount = await dbHelper.getItemCount(
      tableName: dbTables.tableColorPlate,
      limit: 1,
    );
    print('themeCount: $themeCount');
    if (themeCount > 0) {
      final themeList = await db.getAll(tbl: dbTables.tableColorPlate);
      this.themeList.value = themeList
          .map(
            (e) => e['theme_name'].toString(),
      )
          .toList();
      print('themeList: $themeList');
    }
  }

  Future<void> changeTheme({
    required String themeName,
  }) async {
    /// get theme from db
    final theme = await db.getAllWhr(
      tbl: dbTables.tableColorPlate,
      where: 'theme_name = ?',
      whereArgs: [themeName],
      limit: 1,
    );
    if (theme.isNotEmpty) {
      ColorSchema.fromJson(theme[0]);
      await prefs.setSelectedThemeName(
        themeName: themeName,
      );
      await Get.forceAppUpdate();
    }
    selectedThemeColor.value = themeName;
    selectedThemeColor.refresh();
  }

  Future<void> setIsPrinterAllowed(bool value) async {
    isPrinterAllowed.value = value;
    await prefs.setIsPrinterAllowed(
      isPrinterAllowed: value,
    );
  }

  Future<void> setIsEnableDarkMode(bool value) async {
    showSnackBar(
      type: SnackBarType.warning,
      title: appLocalization.upcomingFeature,
      message: appLocalization.comingSoon,
    );
    return;
    isEnableDarkMode.value = value;
    await prefs.setIsEnableDarkMode(
      isEnableDarkMode: value,
    );

    Get.changeTheme(
      Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
    );
    ColorSchema.fromJson(
      Get.isDarkMode ? lightColor : darkColor,
    );
  }

  void changeButton(Buttons button) {
    if (buttons.value == button) {
      buttons.value = null;
      return;
    }
    buttons.value = button;
  }

  Future<void> showPrinterConnectModal() async {
    await Get.dialog(
      DialogPattern(
        title: appLocalization.printerSetup,
        subTitle: appLocalization.connectYourPrinter,
        child: PrinterConnectModalView(),
      ),
    );
  }

  Future<void> clearLicense() async {

    final needExportData = await needExport();
    if (!needExportData) {
      return;
    }

    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) return;

    await prefs.setIsLicenseValid(
      isLicenseValid: false,
    );
    await prefs.setIsLogin(
      isLogin: false,
    );
    Get.offAllNamed(
      Routes.splash,
    );
  }
  Future<bool> needExport() async {
    final salesCount = await dbHelper.getItemCount(
      tableName: dbTables.tableSale,
    );

    if (salesCount > 0) {
      showSnackBar(
        message: appLocalization.exportYourSales,
        type: SnackBarType.warning,
      );
      return false;
    }

    final purchaseCount = await dbHelper.getItemCount(
      tableName: dbTables.tablePurchase,
    );

    if (purchaseCount > 0) {
      showSnackBar(
        message: appLocalization.exportYourPurchase,
        type: SnackBarType.warning,
      );
      return false;
    }

    return true;
  }


  Future<void> sendLogs() async {
    final count = await dbHelper.getItemCount(
      tableName: DbTables().tableLogger,
    );

    if (count == 0) {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.noDataFound,
      );
      return;
    }

    final result = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (result) {
      bool? isSuccessful;

      await dataFetcher(
        future: () async {
          final logs = await dbHelper.getAll(
            tbl: DbTables().tableLogger,
          );
          isSuccessful = await services.postLogs(
            logs: logs,
          );
        },
      );

      if (isSuccessful ?? false) {
        await dbHelper.deleteAll(
          tbl: DbTables().tableLogger,
        );
      }
    }
  }
}
