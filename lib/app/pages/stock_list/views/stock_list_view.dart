import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/stock_list/controllers/stock_list_controller.dart';

//ignore: must_be_immutable
class StockListView extends BaseView<StockListController> {
  StockListView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  