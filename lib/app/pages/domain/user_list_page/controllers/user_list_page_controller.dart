import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sandra/app/entity/user.dart';
import '/app/core/base/base_controller.dart';

class UserListPageController extends BaseController {
  final userManager = UserManager();
  final isSearchSelected = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await userManager.paginate();
  }

  Future<void> onClearSearchText() async {
    userManager.searchTextController.value.clear();
    userManager.allItems.value?.clear();
    userManager.allItems.refresh();
    isSearchSelected.value = false;
    await userManager.paginate();
  }

  Future<void> searchByName(String query) async {
    if (kDebugMode) {
      print('Searching items by name: $query');
    }
    try {
      if (query.isEmpty) {
        userManager.allItems.value = null;
        await userManager.paginate();
        return;
      }

      final value = await dbHelper.getAllWhr(
        tbl: dbTables.tableUsers,
        where:
            "user_name LIKE '%$query%' OR email LIKE '%$query%' OR full_name LIKE '%$query%'",
        whereArgs: [],
        limit: 500,
      );
      userManager.allItems
        ..value = value.map((e) => User.fromJson(e)).toList()
        ..refresh();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error searching items by name: $e');
      }
    }
  }
}
