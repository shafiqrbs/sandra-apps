import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '/app/core/widget/common_text.dart';
import '/app/entity/vendor.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_widget.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/common_icon_text.dart';

class VendorCardView extends BaseWidget {
  final Vendor data;
  final int index;
  final Function() onTap;
  final Function() onReceive;
  final bool showReceiveButton;
  VendorCardView({
    required this.data,
    required this.index,
    required this.onTap,
    required this.onReceive,
    required this.showReceiveButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.zero,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              containerBorderRadius,
            ),
            border: Border.all(
              color: index.isEven
                  ? colors.secondaryColor100
                  : colors.primaryColor100,
            ),
            color:
                index.isEven ? colors.secondaryColor50 : colors.primaryColor50,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          data.name ?? '',
                          style: TextStyle(
                            fontSize: mediumTFSize,
                            color: colors.solidBlackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildIconButton(
                          onTap: () => makeCall(data.mobile ?? '', context),
                          icon: TablerIcons.phone_outgoing,
                          color: colors.primaryColor500,
                        ),
                        18.width,
                        _buildIconButton(
                          onTap: () =>
                              messageCustomer(data.mobile ?? '', context),
                          icon: TablerIcons.message_circle,
                          color: colors.primaryColor500,
                        ),
                        /*18.width,
                        _buildIconButton(
                          onTap: () {},
                          icon: TablerIcons.eye,
                          color: const Color(0xFF989898),
                        ),*/
                        if (showReceiveButton) 18.width,
                        if (showReceiveButton)
                          _buildIconButton(
                            onTap: onReceive,
                            icon: TablerIcons.coin_bitcoin,
                            color: colors.solidRedColor,
                          ),
                      ],
                    ),
                  ],
                ),
                12.height,
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data.mobile ?? '',
                        style: TextStyle(
                          color: const Color(0xFF4D4D4D),
                          fontSize: mediumTFSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        CommonText(
                          text: appLocalization.due,
                          textColor: colors.primaryBlackColor.withOpacity(.5),
                          fontWeight: FontWeight.w400,
                          fontSize: mediumTFSize,
                        ),
                        2.width,
                        CommonText(
                          text: '৳  ${data.balance?.toString() ?? '0'}',
                          textColor: colors.primaryBlackColor,
                          fontWeight: FontWeight.w400,
                          fontSize: mediumTFSize,
                        ),
                      ],
                    ),
                    /*Expanded(
                      child: CommonIconText(
                        text: data.balance?.toString() ?? '0',
                        textColor: colors.solidRedColor,
                        fontWeight: FontWeight.w600,
                        fontSize:paragraphTFSize,
                        icon: TablerIcons.cash,
                      ),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: colors.whiteColor,
          //color: color.withOpacity(.2),
          border: Border.all(
            color: colors.secondaryGreyColor,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: colors.solidGreenColor,
          //color: color,
        ),
      ),
    );
  }
}
