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
                      // Get.to(SyncSettings());
                    },
                    leading: const Icon(TablerIcons.refresh),
                    title: Text(appLocalization.sync),
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
                ],
              ),
            ],
          ),
          Obx(
            () {
              return Column(
                children: [
                  _buildSettingButton(
                    icon: TablerIcons.sun,
                    text: appLocalization.purchaseConfig,
                    trailingIcon: TablerIcons.chevron_right,
                    isOpen: controller.buttons.value == Buttons.purchase,
                    onTap: () {
                      controller.changeButton(Buttons.purchase);
                    },
                  ),
                  if (controller.buttons.value == Buttons.purchase)
                    Container(
                      color: Colors.white,
                      width: Get.width,
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text(appLocalization.purchaseWithMrp),
                            value: 'purchase_with_mrp',
                            groupValue: controller.selectedPurchase.value,
                            onChanged: controller.changePurchase,
                          ),
                          RadioListTile<String>(
                            title: Text(appLocalization.purchasePrice),
                            value: 'purchase_price',
                            groupValue: controller.selectedPurchase.value,
                            onChanged: controller.changePurchase,
                          ),
                          RadioListTile<String>(
                            title: Text(appLocalization.totalPrice),
                            value: 'total_price',
                            groupValue: controller.selectedPurchase.value,
                            onChanged: controller.changePurchase,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton({
    required IconData icon,
    required String text,
    required IconData trailingIcon,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Icon(
                icon,
                color: colors.primaryBaseColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.primaryBaseColor,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                isOpen ? TablerIcons.chevron_down : trailingIcon,
                color: colors.primaryBaseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
