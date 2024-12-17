import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:settings_ui/settings_ui.dart';

import '/app/core/widget/language_change_dropdown.dart';
import '/app/pages/settings/controllers/settings_controller.dart';

//ignore: must_be_immutable
class SettingsView extends BaseView<SettingsController> {
  SettingsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: PageBackButton(
        pageTitle: appLocalization.globalConfiguration,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    final languageController = Get.put(
      LanguageController(),
    );

    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: [
            SettingsList(
              shrinkWrap: true,
              sections: [
                SettingsSection(
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      onPressed: (BuildContext context) {
                        //Get.to(LanguageSettings());
                        controller.changeLocale();
                      },
                      leading: const Icon(TablerIcons.world),
                      title: Text(
                        appLocalization.language,
                        style: commonTextStyle(),
                      ),
                      value: Text(languageController.dropDownValue.value.tr),
                      trailing: const Icon(TablerIcons.chevron_right),
                    ),
                    SettingsTile.navigation(
                      onPressed: (BuildContext context) {
                        controller.isShowThemeColor.value =
                            !controller.isShowThemeColor.value;
                      },
                      leading: const Icon(TablerIcons.moon),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            appLocalization.enableDarkMode,
                            style: commonTextStyle(),
                          ),
                        ],
                      ),
                      trailing: Icon(controller.isShowThemeColor.value
                          ? TablerIcons.chevron_down
                          : TablerIcons.chevron_right),
                      /*trailing: AdvancedSwitch(
                        controller: controller.isEnableDarkMode,
                        onChanged: (value) async {
                          await controller.setIsEnableDarkMode(value);
                        },
                        borderRadius: BorderRadius.circular(4),
                        height: 20,
                        width: 40,
                        activeColor: colors.primaryColor700,
                        inactiveColor: colors.secondaryColor100,
                        initialValue: controller.isEnableDarkMode.value,
                      ),*/
                    ),
                    if (controller.isShowThemeColor.value)
                      SettingsTile(title: _buildThemeColorSchema()),
                    SettingsTile.navigation(
                      onPressed: (BuildContext context) {
                        //Get.toNamed(Routes.accountConfig);
                      },
                      leading: const Icon(TablerIcons.user_cog),
                      title: Text(
                        appLocalization.account,
                        style: commonTextStyle(),
                      ),
                      trailing: const Icon(TablerIcons.chevron_right),
                    ),
                    SettingsTile.navigation(
                      onPressed: (BuildContext context) async {
                        await controller.showPrinterConnectModal();
                      },
                      leading: Obx(
                        () => Icon(
                          TablerIcons.printer,
                          color: controller.connected.value
                              ? colors.greenColor
                              : colors.redColor,
                        ),
                      ),
                      title: Text(
                        appLocalization.printer,
                        style: commonTextStyle(),
                      ),
                      trailing: const Icon(TablerIcons.chevron_right),
                    ),
                    SettingsTile.navigation(
                      onPressed: (BuildContext context) {
                        //Get.to(const AdditionalSettings());
                      },
                      leading: const Icon(TablerIcons.category),
                      title: Text(
                        appLocalization.additional,
                        style: commonTextStyle(),
                      ),
                      trailing: const Icon(TablerIcons.chevron_right),
                    ),
                    SettingsTile.navigation(
                      onPressed: (BuildContext context) {
                        //Get.toNamed(Routes.privacyConfig);
                      },
                      leading: const Icon(TablerIcons.lock),
                      title: Text(
                        appLocalization.privacy,
                        style: commonTextStyle(),
                      ),
                      trailing: const Icon(TablerIcons.chevron_right),
                    ),
                    SettingsTile.navigation(
                      onPressed: (BuildContext context) {
                        Get.toNamed(Routes.helpPage);
                      },
                      leading: const Icon(TablerIcons.help),
                      title: Text(
                        appLocalization.help,
                        style: commonTextStyle(),
                      ),
                      trailing: const Icon(TablerIcons.chevron_right),
                    ),
                    if (isRoleSetting || kDebugMode)
                      SettingsTile.navigation(
                        onPressed: (BuildContext context) async {
                          await controller.clearLicense();
                        },
                        leading: const Icon(TablerIcons.reload),
                        title: Text(
                          appLocalization.reset,
                          style: commonTextStyle(),
                        ),
                        trailing: const Icon(TablerIcons.chevron_right),
                      ),
                    SettingsTile.navigation(
                      onPressed: (BuildContext context) async {
                        await controller.sendLogs();
                      },
                      leading: const Icon(TablerIcons.logs),
                      title: Text(
                        appLocalization.logger,
                        style: commonTextStyle(),
                      ),
                      trailing: const Icon(TablerIcons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle commonTextStyle() {
    return GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildThemeColorSchema() {
    return Container(
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.themeList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final item = controller.themeList[index].obs;

            return Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
              ),
              child: Obx(
                () {
                  return _buildCustomRadioButton(
                    title: item.value ?? '',
                    isSelected:
                        controller.selectedThemeColor.value == item.value,
                    onTap: () {
                      controller.changeTheme(themeName: item.value);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomRadioButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? colors.primaryColor700
                    : colors.secondaryColor200,
              ),
            ),
            child: isSelected
                ? Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primaryColor700,
                    ),
                  )
                : Container(),
          ),
          16.width,
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
