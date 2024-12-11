import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/entity/sales_return.dart';

LabelValue get labelValue => LabelValue(
      label: 'label',
      value: 'value',
      labelFontSize: mediumTFSize,
      valueFontSize: mediumTFSize,
      valueFlex: 1,
      labelFlex: 2,
      valueTextAlign: TextAlign.end,
      padding: EdgeInsets.zero,
    );

class SalesReturnInformationModalView extends StatelessWidget {
  final SalesReturn element;

  const SalesReturnInformationModalView({
    required this.element,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorSchema();
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        color: colors.secondaryColor50,
      ),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.secondaryColor50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(containerBorderRadius),
                topRight: Radius.circular(
                  containerBorderRadius,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 16,
                right: 16,
              ),
              child: Column(
                children: [
                  // title
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.user,
                          text: element.customerName ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.file_invoice,
                          text: '${element.salesInvoice}',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.device_mobile,
                          text: element.customerMobile ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.user,
                          text: element.createdBy ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.calendar,
                          text: element.createdAt ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.info_square_rounded,
                          text: element.payment?.toString() ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: colors.primaryColor50,
            ),
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: CommonText(
                    text: appLocalization.name,
                    fontSize: mediumTFSize,
                    textColor: colors.solidBlackColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: appLocalization.price,
                    fontSize: mediumTFSize,
                    textColor: colors.solidBlackColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: appLocalization.qty,
                    fontSize: mediumTFSize,
                    textColor: colors.solidBlackColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: appLocalization.total,
                    fontSize: mediumTFSize,
                    textColor: colors.solidBlackColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.ph,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: element.items?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final elementItem = element.items![index];

                return Container(
                  //height: 50,
                  width: Get.width,
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: 16,
                    right: 16,
                  ),
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? colors.whiteColor
                        : colors.secondaryColor50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: CommonText(
                          text: '${index + 1}. ${elementItem.stockName ?? ''}',
                          fontSize: 10,
                          textColor: colors.solidBlackColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: elementItem.salesPrice?.toString() ?? '',
                          fontSize: mediumTFSize,
                          textColor: colors.solidBlackColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: elementItem.quantity?.toString() ?? '',
                          fontSize: mediumTFSize,
                          textColor: colors.solidBlackColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          text: elementItem.subTotal?.toString() ?? '',
                          fontSize: mediumTFSize,
                          textColor: colors.solidBlackColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            width: Get.width,
            height: 2,
            decoration: BoxDecoration(
              color: colors.primaryColor50,
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                  //flex: 2,
                  child: Column(
                    mainAxisAlignment: endMAA,
                    crossAxisAlignment: endCAA,
                    children: [
                      Container(
                        width: Get.width,
                        height: 2,
                        decoration: BoxDecoration(
                          color: colors.primaryColor50,
                        ),
                      ),
                      labelValue.copyWith(
                        label: appLocalization.total,
                        value: '${element.subTotal}',
                      ),
                      labelValue.copyWith(
                        label: appLocalization.payment,
                        value: '${element.payment}',
                      ),
                      Container(
                        width: Get.width,
                        height: 2,
                        decoration: BoxDecoration(
                          color: colors.primaryColor50,
                        ),
                      ),
                      labelValue.copyWith(
                        label: appLocalization.adjustment,
                        value: '${element.adjustment}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          24.height
        ],
      ),
    );
  }
}
