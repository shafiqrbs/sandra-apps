import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/pages/home/views/home_view.dart';

import '/app/core/base/base_view.dart';
import '/app/pages/root/controllers/root_controller.dart';
import '/app/pages/root/model/menu_code.dart';
import '/app/pages/root/views/bottom_nav_bar.dart';

// ignore: must_be_immutable
class RootView extends BaseView<RootController> {
  RootView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  @override
  Widget body(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: Obx(
        () => getPageOnSelectedMenu(
          controller.selectedMenuCode,
        ),
      ),
    );
  }

  @override
  Widget? bottomNavigationBar() {
    return BottomNavBar(onItemSelected: controller.onMenuSelected);
  }

  final HomeView homeView = HomeView();
  FavoriteView? favoriteView;
  SettingsView? settingsView;

  Widget getPageOnSelectedMenu(MenuCode menuCode) {
    switch (menuCode) {
      case MenuCode.home:
        return homeView;
      case MenuCode.favorite:
        favoriteView ??= const FavoriteView();
        return favoriteView!;
      case MenuCode.settings:
        settingsView ??= const SettingsView();
        return settingsView!;
      default:
        return OtherView(
          viewParam: menuCode.toString(),
        );
    }
  }
}

class OtherView extends StatelessWidget {
  final String viewParam;

  const OtherView({
    required this.viewParam,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Other View: $viewParam'),
      ),
    );
  }
}

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Favorite View'),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings View'),
      ),
    );
  }
}
