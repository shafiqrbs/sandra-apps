import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_widget.dart';
import '/app/core/singleton_classes/color_schema.dart';

import 'common_header_text.dart';

class SelectedStockListHeader extends BaseWidget {
  SelectedStockListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchema = ColorSchema();
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 32, right: 8),
      decoration: BoxDecoration(
        color: colorSchema.primaryColor300,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonHeaderText(
            flex: 2,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            header: appLocalization.mrp,
          ),
          CommonHeaderText(
            flex: 2,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            header: '(%)',
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
                  header: appLocalization.price,
                ),
                CommonHeaderText(
                  flex: 2,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  header: appLocalization.qty,
                ),
              ],
            ),
          ),
          CommonHeaderText(
            flex: 2,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 8),
            margin: EdgeInsets.zero,
            header: appLocalization.total,
          ),
        ],
      ),
    );
  }
}
