import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/pages/restaurant_module/order_cart/controllers/order_cart_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class OrderCartView extends BaseView<OrderCartController> {
  OrderCartView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    /*return GetX<OrderCartController>(
      init: OrderCartController(
        itemList: purchaseItemList,
        prePurchase: prePurchase,
      ),
      builder: (controller) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black.withOpacity(.5),
          shadowColor: Colors.white.withOpacity(.8),
          elevation: 0,
          child: Center(
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  containerBorderRadius,
                ),
                color: colors.whiteColor,
              ),
              child: Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: centerMAA,
                    children: [
                      _buildSalesItemListView(context),
                      1.percentHeight,
                      _buildCustomerSearch(context),
                      //1.percentHeight,
                      //_buildSelectedCustomerView(context),
                      Stack(
                        children: [
                          Column(
                            children: [
                              _buildTransactionMethod(context),
                              _buildInvoiceSummery(),
                              1.percentHeight,
                              _buildUserSelectView(context),
                              1.percentHeight,
                              _buildBottomButton(context),
                              1.percentHeight,
                            ],
                          ),
                          _buildCustomerListView(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );*/
  }
}
  