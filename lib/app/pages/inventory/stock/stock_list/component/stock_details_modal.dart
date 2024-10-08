import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_widget.dart';
import '/app/entity/stock.dart';
import 'package:nb_utils/nb_utils.dart';

import 'stock_card_view.dart';

class StockDetailsModal extends BaseWidget {
  final Stock element;
  StockDetailsModal({
    required this.element,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: startMAA,
      crossAxisAlignment: startCAA,
      children: [
        12.height,
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            element.name ?? '',
          ),
        ),
        12.height,
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF6F1F7),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: labelValue.copyWith(
                  label: appLocalization.purchasePrice,
                  value: element.purchasePrice.toString(),
                ),
              ),
              Expanded(
                child: labelValue.copyWith(
                  label: appLocalization.qty,
                  value: element.salesPrice.toString(),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: labelValue,
              ),
              Expanded(
                child: labelValue,
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF6F1F7),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: labelValue,
              ),
              Expanded(
                child: labelValue,
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: labelValue,
              ),
              Expanded(
                child: labelValue,
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF6F1F7),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: labelValue,
              ),
              Expanded(
                child: labelValue,
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: labelValue,
              ),
              Expanded(
                child: labelValue,
              ),
            ],
          ),
        ),
        12.height,
      ],
    );
  }
}
