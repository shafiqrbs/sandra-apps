import 'package:get/get.dart';
import '/app/core/abstract_controller/sales_controller.dart';
import '/app/model/sales.dart';
import '/app/core/base/base_controller.dart';

class EditSalesController extends SalesController {
  Sales? sales;

  @override
  Future<void> onInit() async {
    super.onInit();
    setData(sales!);
  }

  void setData(Sales sales) {
    salesItemList.value = sales.salesItem ?? [];
    calculateAllSubtotal();
  }
}
