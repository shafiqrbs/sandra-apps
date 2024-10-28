import 'package:get/get.dart';
import '/app/pages/domain/user_list_page/controllers/user_list_page_controller.dart';

class UserListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserListPageController>(
      () => UserListPageController(),
      fenix: true,
    );
  }
}
  