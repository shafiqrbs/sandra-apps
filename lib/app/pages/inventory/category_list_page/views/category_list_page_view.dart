import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/inventory/category_list_page/controllers/category_list_page_controller.dart';

//ignore: must_be_immutable
class CategoryListPageView extends BaseView<CategoryListPageController> {
  CategoryListPageView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  