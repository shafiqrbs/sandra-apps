import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/language_change_dropdown.dart';
import '/app/pages/settings/controllers/settings_controller.dart';

//ignore: must_be_immutable
class SettingsView extends BaseView<SettingsController> {
  SettingsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryBaseColor,
      centerTitle: false,
      title: Text(
        appLocalization.configuration,
        style: TextStyle(
          fontSize: headerTFSize,
        ),
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
                    ),
                    value: Text(languageController.dropDownValue.value.tr),
                    trailing: const Icon(TablerIcons.chevron_right),
                  ),
                  SettingsTile.navigation(
                    onPressed: (BuildContext context) {
                      // Get.to(AccountSettings());
                    },
                    leading: const Icon(TablerIcons.user_cog),
                    title: Text(appLocalization.account),
                    trailing: const Icon(TablerIcons.chevron_right),
                  ),
                  SettingsTile.navigation(
                    onPressed: (BuildContext context) {
                      // Get.to(const PrinterSettings());
                    },
                    leading: const Icon(TablerIcons.printer),
                    title: Text(appLocalization.printer),
                    trailing: const Icon(TablerIcons.chevron_right),
                  ),
                  SettingsTile.navigation(
                    onPressed: (BuildContext context) {
                      //Get.to(const AdditionalSettings());
                    },
                    leading: const Icon(TablerIcons.category),
                    title: Text(appLocalization.additional),
                    trailing: const Icon(TablerIcons.chevron_right),
                  ),
                  SettingsTile.navigation(
                    onPressed: (BuildContext context) {
                      // Get.to(PrivacySettings());
                    },
                    leading: const Icon(TablerIcons.lock),
                    title: Text(appLocalization.privacy),
                    trailing: const Icon(TablerIcons.chevron_right),
                  ),
                  SettingsTile.navigation(
                    onPressed: (BuildContext context) {
                      // Get.to(PrivacySettings());
                    },
                    leading: const Icon(TablerIcons.help),
                    title: Text(appLocalization.help),
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
}
