import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/inventory/brand_list_page/controllers/brand_list_page_controller.dart';

//ignore: must_be_immutable
class BrandListPageView extends BaseView<BrandListPageController> {
  BrandListPageView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  