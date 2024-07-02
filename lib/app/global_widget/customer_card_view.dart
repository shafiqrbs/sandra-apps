import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:getx_template/app/core/base/base_widget.dart';
import 'package:getx_template/app/core/utils/static_utility_function.dart';
import 'package:getx_template/app/core/widget/common_icon_text.dart';
import 'package:getx_template/app/model/customer.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerCardView extends BaseWidget {
  final Customer data;
  final int index;
  final Function() onTap;
  final Function() onReceive;
  final bool showReceiveButton;
  CustomerCardView({
    required this.data,
    required this.index,
    required this.onTap,
    required this.onReceive,
    required this.showReceiveButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.zero,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  dimensions.containerBorderRadius,
                ),
                color: index.isEven
                    ? colors.evenListColor
                    : colors.evenListColor.withOpacity(.4),
                boxShadow: [
                  BoxShadow(
                    color: colors.backgroundColor,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  children: [
                    Expanded(
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
                                      fontSize: dimensions.paragraphTFSize,
                                      color: colors.primaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          8.height,
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  data.mobile ?? '',
                                  style: TextStyle(
                                    color: colors.secondaryTextColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: CommonIconText(
                                  text: data.balance?.toString() ?? '0',
                                  textColor: colors.dangerBaseColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: dimensions.paragraphTFSize,
                                  icon: TablerIcons.cash,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildIconButton(
                onTap: () => makeCall(data.mobile ?? '', context),
                icon: TablerIcons.phone_outgoing,
                color: colors.colorTwo,
              ),
              _buildIconButton(
                onTap: () => messageCustomer(data.mobile ?? '', context),
                icon: TablerIcons.message_circle,
                color: colors.colorFour,
              ),
              _buildIconButton(
                onTap: () {},
                icon: TablerIcons.eye,
                color: colors.primaryBaseColor,
              ),
              if (showReceiveButton)
                _buildIconButton(
                  onTap: () {},
                  icon: TablerIcons.coin_bitcoin,
                  color: colors.primaryBaseColor,
                ),
            ],
          ),
        ),
      ],
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
        margin: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: colors.primaryLiteColor.withOpacity(.5),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: color,
        ),
      ),
    );
  }
}
