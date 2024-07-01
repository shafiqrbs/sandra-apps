import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/dashboard/controllers/dashboard_controller.dart';

//ignore: must_be_immutable
class DashboardView extends BaseView<DashboardController> {
  DashboardView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      mainAxisAlignment: startMAA,
      crossAxisAlignment: endCAA,
      children: [
        _buildTopBar(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  10.height,
                  _buildTabSelection(),
                  Obx(
                    () {
                      return controller.selectedTab.value ==
                              SelectedTab.dashboard
                          ? _buildDashboard()
                          : _buildReport();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: AppBar().preferredSize.height,
      width: Get.width,
      decoration: BoxDecoration(
        color: colors.primaryBaseColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              TablerIcons.menu_2,
              color: Colors.white,
            ),
          ),
          Text(
            'dashboard'.tr,
            style: TextStyle(
              color: colors.backgroundColor,
              fontSize: dimensions.appBarTFSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(MdiIcons.bell),
                color: Colors.white,
              ),
              // GlobalThreeDotMenu(isAddOption: false,)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelection() {
    return Obx(
      () {
        return Row(
          children: [
            TbdTextButton(
              text: 'dashboard'.tr,
              onPressed: () => mvc.changeTab(SelectedTab.dashboard),
              isSelected: mvc.selectedTab.value == SelectedTab.dashboard,
            ),
            TbdTextButton(
              text: 'report'.tr,
              onPressed: () => mvc.changeTab(SelectedTab.report),
              isSelected: mvc.selectedTab.value == SelectedTab.report,
            ),
          ],
        );
      },
    );
  }
}
