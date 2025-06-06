import 'package:flutter/foundation.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/row_button.dart';
import '/app/entity/sales.dart';
import '/app/global_widget/shimmer_list_view.dart';
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
  final falsePadding = 16.0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<OrderProcessConfirmationController>(
      init: OrderProcessConfirmationController(
        sales: sales,
        isEdit: isEdit,
      ),
      builder: (controller) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(
                falsePadding.value,
              ),
              decoration: BoxDecoration(
                color: colors.whiteColor,
              ),
              child: Column(
                children: [
                  Obx(
                    () => controller.isLoader.value ||
                            controller.connected.value ||
                            !controller.hasPrinter.value
                        ? Container()
                        : Column(
                            children: [
                              Obx(
                                () {
                                  return Text(
                                    controller.msg.value,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              8.height,
                              Row(
                                children: [
                                  RowButton(
                                    buttonName: appLocalization.scan,
                                    onTap: controller.scanBluetooth,
                                  ),
                                ],
                              ),
                              Obx(
                                () => SizedBox(
                                  height: 40.ph,
                                  child: controller.isConnecting.value
                                      ? ShimmerListView(
                                          itemCount: 1,
                                          msg: appLocalization.connecting,
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: controller
                                              .availAbleDevices.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () async {
                                                if (kDebugMode) {
                                                  print(
                                                    'macAdress: ${controller.availAbleDevices[index].macAdress}',
                                                  );
                                                }
                                                await controller.connect(
                                                  controller
                                                      .availAbleDevices[index]
                                                      .macAdress,
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                                      controller
                                                          .availAbleDevices[
                                                              index]
                                                          .name,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    4.width,
                                                    1.percentHeight,
                                                    Text(
                                                      controller
                                                          .availAbleDevices[
                                                              index]
                                                          .macAdress,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                        if (controller.hasPrinter.value)
                          Obx(
                            () => controller.isLoader.value
                                ? const CircularProgressIndicator(
                                    color: Colors.red,
                                  )
                                : RowButton(
                                    buttonName: appLocalization.print,
                                    onTap: controller.salesPrint,
                                    leftIcon: TablerIcons.printer,
                                    buttonBGColor: controller.connected.value
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                          ),
                        4.width,
                        RowButton(
                          buttonName: appLocalization.save,
                          onTap: controller.saveSales,
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
      },
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
