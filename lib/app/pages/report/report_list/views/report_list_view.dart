import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/core/widget/language_change_dropdown.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import 'package:sandra/app/pages/report/report_list/controllers/report_list_controller.dart';
import 'package:settings_ui/settings_ui.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class ReportListView extends BaseView<ReportListController> {
  ReportListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: PageBackButton(
        pageTitle: appLocalization.report,
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
                      controller.goToSystemOverviewReport();
                    },
                    leading: const Icon(TablerIcons.report),
                    title: Text(
                      appLocalization.overview,
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
  