import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/base/base_view.dart';
import 'package:getx_template/app/core/utils/responsive.dart';
import 'package:getx_template/app/core/widget/row_button.dart';
import 'package:getx_template/app/global_widget/shimmer_list_view.dart';
import 'package:nb_utils/nb_utils.dart';

import 'printer_connect_modal_view_controller.dart';

class PrinterConnectModalView
    extends BaseView<PrinterConnectModalViewController> {
  PrinterConnectModalView({super.key});

  @override
  Widget build(BuildContext context) {
    final mvc = Get.put(
      PrinterConnectModalViewController(),
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
                () {
                  return mvc.isLoader.value || mvc.connected.value
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
                                  onTap: mvc.getBluetoothList,
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
                                              final isConnected =
                                                  await mvc.connect(
                                                mvc.availAbleDevices[index]
                                                    .macAdress,
                                              );
                                              if (isConnected) {
                                                Get.back();
                                              }
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                        );
                },
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
