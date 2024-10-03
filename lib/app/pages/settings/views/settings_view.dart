import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/routes/app_pages.dart';
import 'package:settings_ui/settings_ui.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/language_change_dropdown.dart';
import '/app/core/widget/page_back_button.dart';
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
      child: Column(
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
                    onPressed: (BuildContext context) {},
                    leading: const Icon(TablerIcons.moon),
                    title: Text(
                      appLocalization.enableDarkMode,
                      style: commonTextStyle(),
                    ),
                    trailing: AdvancedSwitch(
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
                    ),
                  ),
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
                    onPressed: (BuildContext context) {},
                    leading: const Icon(TablerIcons.printer),
                    title: Text(
                      appLocalization.printer,
                      style: commonTextStyle(),
                    ),
                    trailing: AdvancedSwitch(
                      controller: controller.isPrinterAllowed,
                      onChanged: (value) async {
                        await controller.setIsPrinterAllowed(value);
                      },
                      borderRadius: BorderRadius.circular(4),
                      height: 20,
                      width: 40,
                      activeColor: colors.primaryColor700,
                      inactiveColor: colors.secondaryColor100,
                      initialValue: controller.isPrinterAllowed.value,
                    ),
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle commonTextStyle() {
    return GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }
}
