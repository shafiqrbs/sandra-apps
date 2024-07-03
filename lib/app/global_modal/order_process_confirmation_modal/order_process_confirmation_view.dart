import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/row_button.dart';
import '/app/global_widget/shimmer_list_view.dart';
import '/app/model/sales.dart';
import 'order_process_confirmation_controller.dart';

class OrderProcessConfirmationView
    extends BaseView<OrderProcessConfirmationController> {
  final Sales sales;
  final bool isEdit;
  OrderProcessConfirmationView({
    required this.sales,
    required this.isEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mvc = Get.put(
      OrderProcessConfirmationController(
        sales: sales,
        isEdit: isEdit,
      ),
    );

    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.backgroundColor,
          ),
          child: Column(
            children: [
              Obx(
                () => mvc.isLoader.value || mvc.connected.value
                    ? Container()
                    : Column(
                        children: [
                          Obx(
                            () {
                              return Text(
                                mvc.msg.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          Row(
                            children: [
                              RowButton(
                                buttonName: 'scan'.tr,
                                onTap: mvc.scanBluetooth,
                              ),
                            ],
                          ),
                          Obx(
                            () => SizedBox(
                              height: 40.ph,
                              child: mvc.isConnecting.value
                                  ? ShimmerListView(
                                      itemCount: 1,
                                      msg: 'connecting'.tr,
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: mvc.availAbleDevices.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            if (kDebugMode) {
                                              print(
                                                'macAdress: ${mvc.availAbleDevices[index].macAdress}',
                                              );
                                            }
                                            await mvc.connect(
                                              mvc.availAbleDevices[index]
                                                  .macAdress,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.only(
                                              top: 4,
                                              bottom: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                containerBorderRadius,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  mvc.availAbleDevices[index]
                                                      .name,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                4.width,
                                                1.percentHeight,
                                                Text(
                                                  mvc.availAbleDevices[index]
                                                      .macAdress,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
              ),
              1.percentHeight,
              Container(
                margin: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => mvc.isLoader.value
                          ? const CircularProgressIndicator(
                              color: Colors.red,
                            )
                          : RowButton(
                              buttonName: 'print'.tr,
                              onTap: mvc.salesPrint,
                              leftIcon: TablerIcons.printer,
                              buttonBGColor: mvc.connected.value
                                  ? Colors.green
                                  : Colors.red,
                            ),
                    ),
                    4.width,
                    RowButton(
                      buttonName: 'save'.tr,
                      onTap: mvc.saveSales,
                      leftIcon: TablerIcons.device_floppy,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
}
