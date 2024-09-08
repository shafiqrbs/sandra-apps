import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/core/base/base_widget.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/label_value.dart';
import '/app/entity/stock.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'stock_details_modal.dart';

final labelValue = LabelValue(
  label: 'label',
  value: 'value',
  dividerText: ':',
  labelFontSize: 12,
  valueFontSize: 12,
  labelFlex: 1,
  valueFlex: 1,
  labelFontWeight: 400,
  valueFontWeight: 600,
  labelColor: Colors.black,
  valueColor: Colors.black,
  labelTextAlign: TextAlign.start,
  valueTextAlign: TextAlign.start,
  margin: EdgeInsets.zero,
  padding: EdgeInsets.zero,
  borderColor: Colors.transparent,
  borderWidth: 0,
  fontFamily: GoogleFonts.roboto().fontFamily,
);

class StockCardView extends BaseWidget {
  final Stock element;
  final int index;
  final Rx<bool> isSelectedItem;
  final Rx<bool> isBookmarked;

  StockCardView({
    required this.element,
    required this.index,
    required this.isSelectedItem,
    required this.isBookmarked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (false) {
          Get.dialog(
            DialogPattern(
              title: appLocalization.stockDetails,
              subTitle: '',
              child: StockDetailsModal(
                element: element,
              ),
            ),
          );
        }
      },
      child: Stack(
        children: [
          Container(
            // width: Get.width,
            // height: Get.height * .072,
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
              bottom: 2,
              top: 2,
            ),
            margin: const EdgeInsets.only(
              bottom: 4,
              left: 6,
              right: 6,
            ),
            decoration: BoxDecoration(
              color: index.isEven ? colors.evenListColor : colors.oddListColor,
              borderRadius: BorderRadius.circular(
                containerBorderRadius,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0ff3e9e6),
                  blurRadius: 2,
                  offset: Offset(
                    2,
                    2,
                  ), // shadow direction: bottom right
                ),
              ],
            ),

            child: Container(
              width: Get.width,
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: 12,
              ),
              decoration: BoxDecoration(
                color:
                    index.isEven ? colors.evenListColor : colors.oddListColor,
                borderRadius: BorderRadius.circular(
                  containerBorderRadius,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${element.name ?? ""} ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: colors.primaryTextColor,
                    ),
                  ),
                  3.height,
                  Row(
                    crossAxisAlignment: startCAA,
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.tag,
                          iconSize: 16,
                          iconColor: colors.primaryTextColor,
                          text: element.brandName ?? 'No Brand',
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.category,
                          iconSize: 16,
                          iconColor: colors.primaryTextColor,
                          text: element.categoryName ?? 'No Category',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: Get.width,
                    height: 1,
                    margin: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.borderColor,
                    ),
                  ),
                  9.height,
                  Row(
                    crossAxisAlignment: startCAA,
                    children: [
                      Expanded(
                        child: labelValue.copyWith(
                          label: 'stock'.tr,
                          value: element.quantity.toString(),
                        ),
                      ),
                      Expanded(
                        child: labelValue.copyWith(
                          label: 'purchase'.tr,
                          value: element.purchasePrice.toString(),
                        ),
                      ),
                      Expanded(
                        child: labelValue.copyWith(
                          label: 'mrp'.tr,
                          value: element.salesPrice.toString(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: Get.width * .035,
            top: Get.height * .02,
            child: InkWell(
              onTap: () {
                //show modal
              },
              child: const Icon(
                TablerIcons.chevron_right,
                size: 24,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
