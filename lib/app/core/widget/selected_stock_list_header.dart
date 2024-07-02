import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/singleton_classes/color_schema.dart';

import 'common_header_text.dart';

class SelectedStockListHeader extends StatelessWidget {
  const SelectedStockListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchema = ColorSchema();
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 32, right: 8),
      decoration: BoxDecoration(
        color: colorSchema.primaryLiteColor.withOpacity(.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonHeaderText(
            flex: 2,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            header: 'mrp'.tr,
          ),
          CommonHeaderText(
            flex: 2,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            header: 'per_(%)'.tr,
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                CommonHeaderText(
                  flex: 2,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  header: 'price'.tr,
                ),
                CommonHeaderText(
                  flex: 2,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  header: 'quantity'.tr,
                ),
              ],
            ),
          ),
          CommonHeaderText(
            flex: 2,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 8),
            margin: EdgeInsets.zero,
            header: 'sub_total'.tr,
          ),
        ],
      ),
    );
  }
}
