import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/domain/user_list_page/controllers/user_list_page_controller.dart';

//ignore: must_be_immutable
class UserListPageView extends BaseView<UserListPageController> {
  UserListPageView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  