import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/pages/root/model/menu_code.dart';

class RootController extends BaseController {
  final _selectedMenuCodeController = MenuCode.home.obs;

  MenuCode get selectedMenuCode => _selectedMenuCodeController.value;

  final lifeCardUpdateController = false.obs;

  Future<void> onMenuSelected(MenuCode menuCode) async {
    _selectedMenuCodeController(menuCode);
  }
}
